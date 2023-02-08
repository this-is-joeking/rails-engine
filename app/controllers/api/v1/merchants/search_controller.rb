module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          if params[:name].blank?
            render status: :bad_request
          else
            render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
          end
        end
      end
    end
  end
end
