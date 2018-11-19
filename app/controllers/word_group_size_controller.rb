class WordGroupSizeController < ApplicationController

  def index
    render json: AnagramsPresenter.new.by_word_group_size(params[:limit]), status: 200
  end

end
