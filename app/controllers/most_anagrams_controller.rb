class MostAnagramsController < ApplicationController

  def index
    render json: AnagramsPresenter.most_anagrams
  end

end
