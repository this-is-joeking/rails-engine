# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_error
  rescue_from InvalidParams, with: :render_error

  private

  def render_error(error)
    render json: ErrorSerializer.client_error(error.message), status:
      case error
      when ActiveRecord::RecordInvalid
        :conflict
      when ActiveRecord::RecordNotFound
        :not_found
      else
        :bad_request
      end
  end
end
