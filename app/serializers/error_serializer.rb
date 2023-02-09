class ErrorSerializer
  def self.attribute_errors(error)
    {
      "message": 'your query could not be completed',
      "errors": [
        {
          "title": error.message,
          "status": '409'
        }
      ]
    }
  end

  def self.not_found(error)
    {
      "message": 'your query could not be completed',
      "errors": [
        {
          "title": error.message,
          "status": '404'
        }
      ]
    }
  end

  # def self.no_merchant
  #   {
  #     "message": 'your query could not be completed',
  #     "errors": ['merchant id does not exist']

  #   }
  # end

  # def self.no_item
  #   {
  #     "message": 'your query could not be completed',
  #     "errors": ['item id does not exist']

  #   }
  # end

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
