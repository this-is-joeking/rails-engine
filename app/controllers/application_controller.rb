class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_attributes

  private

  def not_found_response(error)
    render json: ErrorSerializer.not_found(error), status: :not_found
  end

  def invalid_attributes(error)
    render json: ErrorSerializer.attribute_errors(error), status: :conflict
  end
end
