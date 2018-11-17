class WordsController < ApplicationController
  def create
    params[:words].map do |word|
      Word.create(word: word) if Word.find_by_word(word).nil?
    end
    render status: 201
  end

  def destroy
    if params[:slug]
      word = Word.find_by_word(params[:slug])
      word.destroy
    else
      Word.destroy_all
      Anagram.destroy_all
    end
  end
end
