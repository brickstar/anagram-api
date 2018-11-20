class WordAnalyticsController < ApplicationController
  def index
    render json: Word.analytics
  end
end
