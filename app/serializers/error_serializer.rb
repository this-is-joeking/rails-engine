class ErrorSerializer
  def self.errors(model)
    { 
      "message": "your query could not be completed",
      "errors": model.errors.full_messages.map do |error|
        { 'detail' => error }
      end
    }
  end
end
