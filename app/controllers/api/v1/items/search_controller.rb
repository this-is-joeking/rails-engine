module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def show
          if (params[:name] && params[:max_price]) || (params[:name] && params[:min_price]) || params[:min_price].to_f < 0 || params[:max_price].to_f < 0
            render json: ErrorSerializer.bad_request, status: :bad_request
          elsif params[:name] && !params[:name].empty?
            item = Item.find_item_by_name(params[:name])
            if item.nil?
              render json: ItemSerializer.no_item
            else
              render json: ItemSerializer.new(item)
            end
          elsif params[:min_price] || params[:max_price]
            item = Item.find_item_by_price(price_params)
            if item.nil?
              render json: ItemSerializer.no_item
            else
              render json: ItemSerializer.new(item)
            end
          else
            render status: :not_found
          end
        end

        private

        def price_params
          params.permit(:min_price, :max_price)
        end
      end
    end
  end
end
