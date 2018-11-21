class WordGroupSizeController < ApplicationController
  include ProperNounWordGroupSize
  before_action :delete_proper_nouns

  def index
    render json: AnagramsPresenter.new.by_word_group_size(params[:limit]), status: 200
  end

end
