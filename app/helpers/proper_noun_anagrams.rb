module ProperNounAnagrams
  include ApplicationHelper
  def delete_proper_nouns
    if params[:proper_nouns] == "false"
      render json: {
                      word: params[:word],
                      anagrams_without_proper_nouns: without_proper_nouns
                   }
    else
      render json: {
                      word: "#{params[:word]}",
                      anagrams: Anagram.includes(:words).find_by(anagram: params[:word].downcase.chars.sort.join)
                                  .words.pluck(:word).tap { |words| words.delete(params[:word]) }
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
