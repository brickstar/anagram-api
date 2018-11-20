class AnagramsController < ApplicationController
  def show
    render json: AnagramsPresenter.new.anagrams(params[:word], params[:limit], params[:proper_nouns])
  end
end
