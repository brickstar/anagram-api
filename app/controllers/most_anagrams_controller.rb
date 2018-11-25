class MostAnagramsController < ApplicationController

  def index
    render json: AnagramsPresenter.new.most_anagrams
  end

end
