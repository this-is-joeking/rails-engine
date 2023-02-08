module Api
  module V1
    module Items
      class SearchController < ApplicationController
        def show
          if !params[:name].empty?
            item = Item.find_item(params[:name])
            if item.nil?
              render json: ItemSerializer.no_item
            else
              render json: ItemSerializer.new(item)
            end
          else
            render status: :not_found
          end
        end
      end
    end
  end
end