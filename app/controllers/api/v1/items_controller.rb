module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(Item.find(params[:id]))
      end

      def create
        item = Item.create!(item_params)
        render json: ItemSerializer.new(item), status: :created
      end

      def update
        Merchant.find(params[:item][:merchant_id]) if params[:item][:merchant_id].present?
        render json: ItemSerializer.new(Item.update(params[:id], item_params))
      end

      def destroy
        Item.find(params[:id]).find_dependent_invoices.each(&:destroy)
        Item.destroy(params[:id])
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
