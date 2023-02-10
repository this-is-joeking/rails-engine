module Api
  module V1
    class ItemsController < ApplicationController
      before_action :find_item, only: %i[show destroy]

      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        render json: ItemSerializer.new(@item)
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
        @item.find_dependent_invoices.each(&:destroy)
        Item.destroy(params[:id])
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def find_item
        @item = Item.find(params[:id])
      end
    end
  end
end
