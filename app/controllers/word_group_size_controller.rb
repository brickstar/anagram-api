class WordGroupSizeController < ApplicationController
  include ProperNounWordGroupSize
  include LimitValidator
  before_action :delete_proper_nouns, :validate_query_limit

  def index
    render json: AnagramsPresenter.new.by_word_group_size(params[:limit]), status: 200
  end

end
