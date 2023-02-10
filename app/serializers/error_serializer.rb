class ErrorSerializer
  def self.bad_query(error)
    {
      "message": 'your query could not be completed',
      "errors": [
        if error.is_a?(String)
          error
        else
          message(error)
        end
      ]
    }
  end

  def self.message(params)
    error_msg = 'missing value for the key entered' if params.values.include?('')

    error_msg = 'missing key and value' if (params.keys & %w[name min_price max_price]).empty?

    error_msg = 'min_price cannot be greater than max_price' if params[:min_price].to_f > params[:max_price].to_f

    error_msg
  end
end
