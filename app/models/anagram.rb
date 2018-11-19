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
    grouped_by_words_count(limit).map do |words_count, anagram|
      {
        anagrams_count: words_count,
        words: anagram.map { |anagram| anagram.words.map { |word| word.word } }
      }
    end
  end

  private

    def self.grouped_by_words_count(limit)
      anagrams_by_words_size(limit).group_by { |anagram| anagram.words_count }
    end

    def self.anagrams_by_words_size(limit)
      includes(:words)
      .where("words_count >= #{limit}")
      .order(words_count: :desc)
    end

end
