class ErrorSerializer
  
  def self.not_found_or_bad_attributes(error, status)
    {
      "message": 'your query could not be completed',
      "errors": [
        {
          "title": error.message,
          "status": status
        }
      ]
    }
  end

  def self.bad_request(params)
    {
      "message": 'your query could not be completed',
      "errors": message(params)
    }
  end

  def self.message(params)
    errors = []
    errors << 'your query could not be completed without a value for the key entered' if params.values.include?('')

    errors << 'your query could not be completed without passing key and value to query' if (params.keys & %w[name
                                                                                                              min_price max_price]).empty?

    errors << 'min_price cannot be greater than max_price' if params[:min_price].to_f > params[:max_price].to_f
    errors
  end
end
