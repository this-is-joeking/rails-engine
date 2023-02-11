class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from InvalidParams, with: :render_error

  private

  def render_error(error)
    render json: ErrorSerializer.client_error(error.message), status:
      if error.is_a?(ActiveRecord::RecordInvalid)
        :conflict
      elsif error.is_a?(ActiveRecord::RecordNotFound)
        :not_found
      else
        :bad_request
      end
  end
end
