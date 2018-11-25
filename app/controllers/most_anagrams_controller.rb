class MostAnagramsController < ApplicationController

  def index
    render json: AnagramsPresenter.new.largest_anagram_set
  end

end
