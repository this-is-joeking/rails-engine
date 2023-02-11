# frozen_string_literal: true

class ErrorSerializer
  def self.client_error(error)
    { "message": 'your query could not be completed', "errors": [error] }
  end
end
