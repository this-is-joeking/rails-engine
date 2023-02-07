module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def show
          if Item.where(id: params[:item_id]).exists?
            item = Item.find(params[:item_id])
            render json: MerchantSerializer.new(item.merchant)
          else
            render status: :not_found
          end
        end
      end
    end
  end
end
