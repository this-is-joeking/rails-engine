class ErrorSerializer
  def self.errors(model)
    {
      "errors": model.errors.full_messages.map do |error|
        { "detail"=> error }
        # require 'pry'; binding.pry
      end
    }
  end
end