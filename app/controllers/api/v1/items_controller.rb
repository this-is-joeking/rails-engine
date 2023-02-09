module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render json: ItemSerializer.new(Item.all)
      end

      def show
        if Item.where(id: params[:id]).exists?
          render json: ItemSerializer.new(Item.find(params[:id]))
        else
          render json: ErrorSerializer.no_item, status: :not_found
        end
      end

      def create
        item = Item.create(item_params)
        if item.save
          render json: ItemSerializer.new(item), status: :created
        else
          render json: ErrorSerializer.errors(item), status: :conflict
        end
      end

      def update
        if Merchant.where(id: params[:item][:merchant_id]).exists? || !params[:item][:merchant_id].present?
          render json: ItemSerializer.new(Item.update(params[:id], item_params))
        else
          render status: :not_found
        end
      end

      def destroy
        if Item.where(id: params[:id]).exists?
          Item.find(params[:id]).find_dependent_invoices.each(&:destroy)
          Item.destroy(params[:id])
          render status: :no_content
        else
          render status: :not_found
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
