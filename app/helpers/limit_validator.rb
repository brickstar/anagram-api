module LimitValidator
  def validate_query_limit
    if params[:size].to_i < 2 || params[:size].to_i > 7 || params[:size].to_i == 0
      render json: { "message": "please specify an integer size greater than 1 or less than 8"}
    end
  end
end
