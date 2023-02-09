module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def show
          if invalid_params_combo? || invalid_params_values? || conflicting_price_values?
            render json: ErrorSerializer.bad_request(params), status: :bad_request
          elsif !params[:name].blank?
            render_item(Item.find_item_by_name(params[:name]))
          elsif params[:min_price].present? || params[:max_price].present?
            render_item(Item.find_item_by_price(price_params))
          else
            render json: ErrorSerializer.bad_request(params), status: :bad_request
          end
        end

        private

        def price_params
          params.permit(:min_price, :max_price)
        end

        def invalid_params_combo?
          params[:name] && (params[:max_price] || params[:min_price])
        end

        def invalid_params_values?
          params[:min_price].to_f.negative? || params[:max_price].to_f.negative? || params[:name] == ''
        end

        def conflicting_price_values?
          if params[:min_price] && params[:max_price]
            params[:min_price].to_f > params[:max_price].to_f
          else
            false
          end
        end

        def render_item(item)
          if item.nil?
            render json: ItemSerializer.no_item
          else
            render json: ItemSerializer.new(item)
          end
        end
      end
    end
  end
end
