module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
        end
      end
    end
  end
end
