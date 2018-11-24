class AnagramsController < ApplicationController
  include ProperNounAnagrams
  include WordValidator
  before_action :validate_word, :delete_proper_nouns, only: [:show]

  def show
    render json: AnagramsPresenter.new.anagrams(params[:word], params[:limit], params[:proper_nouns])
  end

end
