module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def show
          if invalid_params_combo? || invalid_params_values?
            render json: ErrorSerializer.bad_request, status: :bad_request
          elsif params[:name] && !params[:name].empty?
            render_item(Item.find_item_by_name(params[:name]))
          elsif params[:min_price] || params[:max_price]
            render_item(Item.find_item_by_price(price_params))
          else
            render status: :not_found
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
          params[:min_price].to_f < 0 || params[:max_price].to_f < 0 || params[:name] == ''
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
