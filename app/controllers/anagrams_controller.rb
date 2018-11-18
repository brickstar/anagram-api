class AnagramsController < ApplicationController
  def show
    render json: Anagram.anagrams(params[:slug], params[:limit])
  end
end
