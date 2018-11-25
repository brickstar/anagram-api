class WordsController < ApplicationController
  def create
    params[:words].map do |word|
      anagram = Anagram.find_or_create_by(anagram: word.chars.sort.join)
      Word.find_or_create_by(word: word, anagram: anagram, word_length: word.length)
    end
    render status: 201
  end

  def destroy
    if params[:word].nil? || params[:word].empty?
      Word.delete_all
      Anagram.delete_all
    else
      word = Word.find_by_word(params[:word])
      word.destroy
    end
    render status: 204
  end
end
