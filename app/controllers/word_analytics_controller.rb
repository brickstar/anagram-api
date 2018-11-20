class WordAnalyticsController < ApplicationController
  def index
    render json: WordsPresenter.new.analytics
  end
end
