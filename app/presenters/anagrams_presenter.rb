class AnagramsPresenter
include ApplicationHelper

  def initialize(word = nil)
    @word = word
    @anagrams = []
  end

  def anagrams(limit = nil, proper_nouns = nil)
    apply_limit(limit) if limit
    delete_proper_nouns if proper_nouns == "false"
    all_anagrams if proper_nouns != "false" && limit.nil?
    { word: @word, anagrams: @anagrams }
  end

  def anagram_groups_by_size(size, proper_nouns = nil)
    if proper_nouns == "false"
      without_proper_nouns(size)
    else
      build_anagram_groups_by_size(size)
    end
  end

  def self.most_anagrams
    {
      anagrams_count: count_of_largest_anagram_set,
      anagrams: serialized_words_from_largest_anagram_set
    }
  end

  private
    def all_anagrams
      @anagrams = find_anagrams(@word)
      remove_query_word
    end

    def delete_proper_nouns
      @anagrams = find_anagrams(@word).delete_if do |word|
        capitalized?(word)
      end
      remove_query_word
    end

    def apply_limit(limit)
      @anagrams = find_anagrams(@word).tap { |words| words.delete(@word) }.take(limit.to_i)
    end

    def remove_query_word
      @anagrams.tap { |words| words.delete(@word) }
    end

    def find_anagrams(word)
      Anagram.includes(:words)
      .find_by(anagram: word.downcase.chars.sort.join)
      .words
      .pluck(:word)
    end

    def build_anagram_groups_by_size(size)
      group_keys_by_words_count(size).map do |words_count, keys|
        { sets_of: words_count, anagrams: get_anagrams_from_keys(keys) }
      end
    end

    def group_keys_by_words_count(size)
      get_keys_greater_than_or_equal_to_size(size).group_by { |anagram| anagram.words_count }
    end

    def get_keys_greater_than_or_equal_to_size(size)
      Anagram.includes(:words)
        .where("words_count >= ?", size)
        .order(words_count: :desc)
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

    # in the dataset generated from seedsfile the largest anagram set is 7
    # there is only 1 set of anagrams of size 7. I built these methods to support
    # seeding the full dictionary where the largest anagram set is more likely
    # to have more than one set of anagrams of the largest size.
    # functionality remains the same with one set vs multiple sets
    def self.serialized_words_from_largest_anagram_set(anagrams = nil)
      words_from_largest_anagram_key.each_slice(count_of_largest_anagram_set).to_a
    end

    def self.words_from_largest_anagram_key
      keys_with_most_anagrams.pluck(:word)
    end

    def self.keys_with_most_anagrams
      Anagram.includes(:words).where(words_count: count_of_largest_anagram_set)
    end

    def self.count_of_largest_anagram_set
      @_count ||= Anagram.maximum(:words_count)
    end

end
