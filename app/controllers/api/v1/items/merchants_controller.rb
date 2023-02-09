module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def show
          item = Item.find(params[:item_id])
          render json: MerchantSerializer.new(item.merchant)
        end
      end
    end
  end
end
