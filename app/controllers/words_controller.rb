class WordsController < ApplicationController
  def create
    params[:words].map do |word|
      Word.create(word: word) if Word.find_by_word(word).nil?
    end
    render status: 201
  end
end
