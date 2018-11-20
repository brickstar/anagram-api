class WordAnalyticsController < ApplicationController
  def index
    render json: Anagram.anagram_info
  end
end
