class WordsController < ApplicationController
  def create
    params[:words].map do |word|
      anagram = Anagram.find_or_create_by(anagram: word.chars.sort.join)
      Word.find_or_create_by(word: word, anagram: anagram)
    end
    render status: 201
  end

  def destroy
    if params[:slug].nil?
      Word.delete_all
      Anagram.delete_all
    else
      word = Word.find_by_word(params[:slug])
      word.destroy
    end
  end
end
