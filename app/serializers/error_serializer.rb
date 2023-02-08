class ErrorSerializer
  def self.errors(model)
    {
      "message": 'your query could not be completed',
      "errors": model.errors.full_messages.map do |error|
        { 'detail' => error }
      end
    }
  end

  def self.bad_request
    {
      "message": 'your query could not be completed with those params',
      "errors": {}
    }
  end
end
