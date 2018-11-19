class AnagramWordsController < ApplicationController

  def destroy
    anagram = Anagram.includes(:words).find_by(anagram: params[:word].chars.sort.join)
    anagram.words.destroy_all
    Anagram.destroy(anagram.id)
  end
end
