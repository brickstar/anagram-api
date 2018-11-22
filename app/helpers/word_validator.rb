module WordValidator
  def validate_word
    if Anagram.find_by(anagram: params[:word].chars.sort.join).nil?
      render json: { "#{params[:word]}": "not_found", anagrams: [] }, status: 200
    end
  end
end
