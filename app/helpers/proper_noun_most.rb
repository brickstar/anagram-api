module ProperNounMost
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      render json: {
                      word_count: words_without_proper_nouns.first.count,
                      words: words_without_proper_nouns
                   }
    end
  end

  def capitalized?(word)
    word == word.capitalize
  end

  def most_anagrams
    AnagramsPresenter.new.most_anagrams
  end

  def words_without_proper_nouns
    most_anagrams[:words].each do |word_array|
      word_array.delete_if do |word|
        capitalized?(word)
      end
    end
  end
end
