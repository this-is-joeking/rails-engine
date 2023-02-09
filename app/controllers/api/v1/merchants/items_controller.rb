module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          if Merchant.where(id: params[:merchant_id]).exists?
            render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
          else
            render json: ErrorSerializer.no_merchant, status: :not_found
          end
        end
      end
    end
  end
end
