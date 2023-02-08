class ErrorSerializer
  def self.errors(model)
    {
      "message": 'your query could not be completed',
      "errors": model.errors.full_messages.map do |error|
        { 'detail' => error }
      end
    }
  end

  def self.bad_request(params)
    {
      "message": "your query could not be completed",
      "errors": message(params)
    }
  end

  # def self.bad_request
  #   {
  #     "message": "your query could not be completed",
  #     "errors": {}
  #   }
  # end

  def self.message(params)
    errors = []
    errors << "your query could not be completed without a value for name" if params[:name] == ''
    
    errors << "your query could not be completed without params" if !params[:name]

    errors 
  end
end
