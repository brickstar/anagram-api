class Anagram < ApplicationRecord
  has_many :words

  def self.anagrams(slug, limit = 0)
    if limit
      {
        anagrams: includes(:words)
                  .find_or_create_by(anagram: slug.chars.sort.join)
                  .words.pluck(:word)
                  .take(limit.to_i)
      }
    else
      {
        anagrams: includes(:words)
                  .find_or_create_by(anagram: slug.chars.sort.join)
                  .words.pluck(:word)
                  .tap do |words|
                    words.delete(slug)
                  end
      }
    end
  end

  def self.by_word_group_size(limit)
    anagrams = Anagram.includes(:words).where("words_count >= #{limit}").order(words_count: :desc)
    grouped = anagrams.group_by { |anagram| anagram.words_count }
    grouped.map do |words_count, anagram|
      {
        words_count: words_count,
        words: anagram.map { |anagram| anagram.words.map { |word| word.word } }
      }
    end
  end
end
