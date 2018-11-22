class AnagramsController < ApplicationController
  include ProperNounAnagrams
  include WordValidator
  before_action :delete_proper_nouns, :validate_word, only: [:show]

  def show
    render json: AnagramsPresenter.new.anagrams(params[:word], params[:limit], params[:proper_nouns])
  end

end
