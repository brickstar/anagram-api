module SizeValidator
  def validate_query_size
    if params[:size].to_i < 2 || params[:size].to_i > 7 || params[:size].to_i == 0
      render json: { "message": "please specify an integer size greater than 1 or less than 8"}, status: 400
    end
  end
end
