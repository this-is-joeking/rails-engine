module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          if !params[:name]
            raise InvalidParams.new('missing key name and value')
          elsif params[:name] == ''
            raise InvalidParams.new('you must specify a value for name')
          else
            render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
          end
        end
      end
    end
  end
end
