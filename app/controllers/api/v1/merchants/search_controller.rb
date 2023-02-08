module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          # require 'pry'; binding.pry
          render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
        end
      end
    end
  end
end