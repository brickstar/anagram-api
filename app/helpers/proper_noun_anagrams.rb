module ProperNounAnagrams
  include ApplicationHelper
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      render json: {
                      anagrams: without_proper_nouns
                   }
    end
  end

  def get_anagrams
    AnagramsPresenter.new.anagrams(params[:word], params[:limit], params[:proper_nouns])[:anagrams]
  end

  def without_proper_nouns
    get_anagrams.delete_if do |word|
      capitalized?(word)
    end
  end

end
