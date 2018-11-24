class AnagramsController < ApplicationController
  include WordValidator
  before_action :validate_word, only: [:show]

  def show
    render json: AnagramsPresenter.new(params[:word]).anagrams(params[:limit], params[:proper_nouns])
  end

end
