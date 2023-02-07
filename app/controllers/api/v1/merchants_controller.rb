module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render json: MerchantSerializer.new(Merchant.all)
      end

      def show
        if Merchant.where(id: params[:id]).exists?
          render json: MerchantSerializer.new(Merchant.find(params[:id]))
        else
          render status: :not_found
        end
      end
    end
  end
end
