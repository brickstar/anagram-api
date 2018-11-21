class CheckAnagramsController < ApplicationController
  def show
    if words_to_validate.length == 1
      render json: { anagrams?: true }
    else
      render json: { anagrams?: false}
    end
  end

  private

    def words_to_validate
      params[:words].group_by { |word| word.downcase.chars.sort }.values
    end
end
