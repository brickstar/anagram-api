module WordValidator
  def validate_word
    if Anagram.find_by(anagram: params[:word].downcase.chars.sort.join).nil? || Word.find_by(word: params[:word]).nil?
      render json: { "#{params[:word]}": "not_found", anagrams: [] }, status: 200
    end
  end
end
