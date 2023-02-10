class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_attributes

  private

  def not_found_response(error)
    # need to make sure this status code is tested in the json response
    render json: ErrorSerializer.bad_query(error.message), status: :not_found
  end

  def invalid_attributes(error)
    # need to make sure this status code is tested in the json response
    render json: ErrorSerializer.bad_query(error.message), status: :conflict
  end
end
