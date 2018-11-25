class WordGroupSizeController < ApplicationController
  include LimitValidator
  before_action :validate_query_limit

  def index
    render json: AnagramsPresenter.new.anagram_groups_greater_than_or_equal_to_size(params[:size], params[:proper_nouns]), status: 200
  end

end
