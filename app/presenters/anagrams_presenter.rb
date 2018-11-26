class AnagramsPresenter
  include ApplicationHelper
  def initialize(word = nil)
    @word = word
    @anagrams = []
    @finder = AnagramFinder.new(word)
  end

  def anagrams(limit = nil, proper_nouns = nil)
    return invalid_limit_message if invalid_limit?(limit)
    apply_limit(limit) if limit
    delete_proper_nouns if proper_nouns == "false"
    all_anagrams if proper_nouns != "false" && limit.nil?
    { word: @word, anagrams: @anagrams }
  end

  def anagram_groups_by_size(size, proper_nouns = nil)
    return without_proper_nouns(size) if proper_nouns == "false"
    build_anagram_groups_by_size(size)
  end

  def largest_anagram_set
    build_largest_anagrams_set
  end

  private
    def invalid_limit_message
      { message: "invalid limit, must be 0 or greater"}
    end

    def invalid_limit?(limit)
      limit.to_i < 0
    end

    def apply_limit(limit)
      @anagrams = @finder.find_anagrams.tap { |words| words.delete(@word) }.take(limit.to_i)
    end

    def delete_proper_nouns
      @anagrams = delete_capitalized_words(@finder.find_anagrams)
      remove_query_word
    end

    def all_anagrams
      @anagrams = @finder.find_anagrams
      remove_query_word
    end

    def remove_query_word
      @anagrams.tap { |words| words.delete(@word) }
    end

    def build_anagram_groups_by_size(size)
      @finder.group_keys_by_words_count(size).map do |words_count, keys|
        { sets_of: words_count, anagrams: get_anagrams_from_keys(keys) }
      end
    end

    def get_anagrams_from_keys(keys)
      keys.map { |key| key.words.pluck(:word) }
    end

    # takes hash of anagrams grouped by size and rebuilds without proper nouns
    def without_proper_nouns(size)
      build_anagram_groups_by_size(size).inject(Array.new) do |ary, element, hash = Hash.new([])|
        hash[:sets_of] = element[:sets_of]
        hash[:anagrams] = element[:anagrams].map { |anagrams| delete_capitalized_words(anagrams) }
        ary << hash
        ary
      end
    end

    def build_largest_anagrams_set
      {
        anagrams_count: @finder.count_of_largest_anagram_set,
        anagrams: serialized_words_from_largest_anagram_set
      }
    end

    def serialized_words_from_largest_anagram_set
      @finder.words_from_largest_anagram_key.each_slice(@finder.count_of_largest_anagram_set).to_a
    end
end
