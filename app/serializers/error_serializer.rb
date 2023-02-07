class ErrorSerializer
  def self.errors(model)
    {
      "errors": model.errors.full_messages.map do |error|
        { 'detail' => error }
      end
    }
  end
end
