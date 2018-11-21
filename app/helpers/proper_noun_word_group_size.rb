module ProperNounWordGroupSize
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      render json: without_proper_nouns
    end
  end

  def get_anagrams_by_word_group_size
    AnagramsPresenter.new.by_word_group_size(params[:limit])
  end

  def capitalized?(word)
    word == word.capitalize
  end

  def without_proper_nouns
    get_anagrams_by_word_group_size.each do |element|
      element[:words].each do |ary|
        ary.delete_if do |word|
          capitalized?(word)
        end
      end
    end
  end
end
