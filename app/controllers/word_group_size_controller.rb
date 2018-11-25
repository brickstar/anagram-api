class WordGroupSizeController < ApplicationController
  include SizeValidator
  before_action :validate_query_size

  def index
    render json: AnagramsPresenter.new.anagram_groups_by_size(params[:size], params[:proper_nouns]), status: 200
  end

end
