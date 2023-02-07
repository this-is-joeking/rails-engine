class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def update
    if Merchant.where(id: params[:item][:merchant_id]).exists? || !params[:item][:merchant_id].present?
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render status: 404
    end
  end

  def destroy
    Item.delete(params[:id]) #should destroy any dependent data
    render status: 204
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end