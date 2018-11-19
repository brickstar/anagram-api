class AnagramsController < ApplicationController
  def show
    render json: AnagramsPresenter.new.anagrams(params[:word], params[:limit])
  end
end
