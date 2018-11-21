module ProperNounAnagrams
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      anagrams = AnagramsPresenter.new.anagrams(params[:word], params[:limit], params[:proper_nouns])[:anagrams]
      anagrams = anagrams.delete_if do |word|
        capitalized?(word)
      end
      render json: {
                      anagrams: anagrams
                   }
    end
  end

  def capitalized?(word)
    word == word.capitalize
  end
end
