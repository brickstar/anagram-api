class WordGroupSizeController < ApplicationController

  def index
    render json: Anagram.by_word_group_size(params[:limit]), status: 200
  end

end
