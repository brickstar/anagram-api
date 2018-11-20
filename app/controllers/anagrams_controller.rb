class AnagramsController < ApplicationController
  include ProperNoun
  before_action :delete_proper_nouns

  def show
    render json: AnagramsPresenter.new.anagrams(params[:word], params[:limit], params[:proper_nouns])
  end


end
