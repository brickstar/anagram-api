class CheckAnagramsController < ApplicationController
  def show
    to_validate = params[:words].group_by { |el| el.chars.sort }.values
    if to_validate.length == 1
      render json: { anagrams?: true }
    else
      render json: { anagrams?: false}
    end
  end
end
