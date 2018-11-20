class AnagramsPresenter

  def anagrams(word, limit = 0)
    if limit
      {
        anagrams: Anagram.includes(:words)
                  .find_or_create_by(anagram: word.chars.sort.join)
                  .words.pluck(:word)
                  .take(limit.to_i)
      }
    else
      {
        anagrams: Anagram.includes(:words)
                  .find_or_create_by(anagram: word.chars.sort.join)
                  .words.pluck(:word)
                  .tap do |words|
                    words.delete(word)
                  end
      }
    end
  end

  def by_word_group_size(limit)
    grouped_by_words_count(limit).map do |words_count, anagram|
      {
        anagrams_count: words_count,
        words: anagram.map { |anagram| anagram.words.map { |word| word.word } }
      }
    end
  end

  def most_anagrams
    {
      word_count: anagrams_with_most_words.first.words_count,
      words: anagrams_with_most_words.map { |anagram| anagram.words.map { |word| word.word }}
    }
  end

  private

    def anagrams_with_most_words
      Anagram.includes(:words).where(words_count: Anagram.maximum(:words_count))
    end

    def grouped_by_words_count(limit)
      anagrams_by_words_size(limit).group_by { |anagram| anagram.words_count }
    end

    def anagrams_by_words_size(limit)
      Anagram.includes(:words)
      .where("words_count >= #{limit}")
      .order(words_count: :desc)
    end

end
