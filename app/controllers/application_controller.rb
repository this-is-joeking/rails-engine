class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, with: :render_error

  private

  def render_error(error)
    render json: ErrorSerializer.client_error(error.message), status:
      if error.is_a?(ActiveRecord::RecordInvalid)
        :conflict
      else
        :not_found
      end
  end
end
