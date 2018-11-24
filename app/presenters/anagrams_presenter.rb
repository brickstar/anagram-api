class AnagramsPresenter
include ApplicationHelper

  def initialize(word = nil)
    @word = word
    @anagrams = []
  end

  def anagrams(limit = 0, proper_nouns = nil)
    delete_proper_nouns if proper_nouns == "false"
    anagrams_by_limit(limit) if limit
    all_anagrams if proper_nouns != "false" && limit.nil?
    { word: @word, anagrams: @anagrams}
  end

  def all_anagrams
    @anagrams = find_anagrams(@word).tap { |words| words.delete(@word) }
  end

  def delete_proper_nouns
    @anagrams = find_anagrams(@word).delete_if do |word|
      capitalized?(word)
    end
    @anagrams.tap { |words| words.delete(@word) }
  end

  def anagrams_by_limit(limit)
    @anagrams = find_anagrams(@word).take(limit.to_i)
  end

  def by_word_group_size(limit)
    grouped_by_words_count(limit).map do |words_count, anagrams|
      {
        anagrams_count: words_count,
        words: serialized_words_by_size(anagrams)
      }
    end
  end

  def most_anagrams
    {
      word_count: anagrams_with_most_words.first.words_count,
      words: serialized_words_from_largest_anagram_set
    }
  end

  private

    def serialized_words_by_size(anagrams)
      words_by_size(anagrams).each_slice(anagrams.first.words_count)
    end

    def words_by_size(anagrams)
      get_words_from_anagrams(anagrams).flatten.map { |word| word.word }
    end

    def serialized_words_from_largest_anagram_set(anagram = nil)
      words_from_largest_anagrams.each_slice(count_of_largest_anagram_set).to_a
    end

    def get_words_from_anagrams(anagrams)
      anagrams.map { |anagram| anagram.words }
    end

    def words_from_largest_anagrams
      anagrams_with_most_words
        .pluck(:word)
    end

    def find_anagrams(word)
      Anagram.includes(:words)
        .find_by(anagram: word.downcase.chars.sort.join)
        .words
        .pluck(:word)
    end

    def count_of_largest_anagram_set
      @_count ||= Anagram.maximum(:words_count)
    end

    def anagrams_with_most_words
      Anagram.includes(:words).where(words_count: count_of_largest_anagram_set)
    end

    def grouped_by_words_count(limit)
      anagrams_by_words_size(limit).group_by { |anagram| anagram.words_count }
    end

    def anagrams_by_words_size(limit)
      Anagram.includes(:words)
        .where("words_count >= ?", limit)
        .order(words_count: :desc)
    end

end
