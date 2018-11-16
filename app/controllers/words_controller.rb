class WordsController < ApplicationController
  def create
    params[:words].map do |word|
      Word.create(word: word) if Word.find_by_word(word).nil?
    end
  end
end
