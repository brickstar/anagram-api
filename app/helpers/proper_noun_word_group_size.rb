module ProperNounWordGroupSize
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      render json: words_without_proper_nouns
    end
  end

  def get_anagrams_by_word_group_size
    AnagramsPresenter.new.by_word_group_size(params[:limit])
  end

  def capitalized?(word)
    word == word.capitalize
  end

  def words_without_proper_nouns
    get_anagrams_by_word_group_size.each do |element|
      element[:words].each do |ary|
        delete_capitalized_words(ary)
      end
    end
  end

  def delete_capitalized_words(word_array)
    word_array.delete_if { |word| capitalized?(word) }
  end

end
