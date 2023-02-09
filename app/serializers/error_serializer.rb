class ErrorSerializer
  def self.errors(model)
    {
      "message": 'your query could not be completed',
      "errors": model.errors.full_messages.map do |error|
        { 'detail' => error }
      end
    }
  end

  def self.no_merchant
    {
      "message": 'your query could not be completed',
      "errors": ['merchant id does not exist']

    }
  end

  def self.no_item
    {
      "message": 'your query could not be completed',
      "errors": ['item id does not exist']

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
    errors << 'your query could not be completed without a value for name' if params[:name] == ''

    errors << 'your query could not be completed without valid params' unless params[:name]

    errors
  end
end
