class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    if Merchant.where(id: params[:merchant_id]).exists?
      render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    else
      render status: 404
    end
  end
end