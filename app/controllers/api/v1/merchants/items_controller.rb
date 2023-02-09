module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          render json: ItemSerializer.new(Item.where(merchant: Merchant.find(params[:merchant_id])))
        end
      end
    end
  end
end
