class AnagramFinder
  def initialize(word)
    @word = word
  end

  def find_anagrams
    Anagram.includes(:words)
      .find_by(anagram: @word.downcase.chars.sort.join)
      .words
      .pluck(:word)
  end

  def group_keys_by_words_count(size)
    get_anagram_keys_by_size(size).group_by { |anagram| anagram.words_count }
  end

  def count_of_largest_anagram_set
    @_count ||= Anagram.maximum(:words_count)
  end

  def words_from_largest_anagram_key
    keys_with_most_anagrams.pluck(:word)
  end

  private
    def get_anagram_keys_by_size(size)
      Anagram.includes(:words)
        .where("words_count >= ?", size)
        .order(words_count: :desc)
    end

    def keys_with_most_anagrams
      Anagram.includes(:words).where(words_count: count_of_largest_anagram_set)
    end
end
