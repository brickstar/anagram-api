class AnagramsController < ApplicationController
  def show
    render json: AnagramsPresenter.new.anagrams(params[:slug], params[:limit])
  end
end
