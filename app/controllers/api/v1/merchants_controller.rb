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
          render json: ErrorSerializer.no_merchant, status: 404
        end
      end
    end
  end
end
