class AnagramWordsController < ApplicationController

  def destroy
    find_anagram.words.destroy_all
    Anagram.destroy(find_anagram.id)
  end

  private
    def find_anagram
      @_anagram ||= Anagram.includes(:words).find_by(anagram: params[:word].chars.sort.join)
    end
end
