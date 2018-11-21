class MostAnagramsController < ApplicationController
  include ProperNounMost
  before_action :delete_proper_nouns
  
  def index
    render json: AnagramsPresenter.new.most_anagrams
  end
end
