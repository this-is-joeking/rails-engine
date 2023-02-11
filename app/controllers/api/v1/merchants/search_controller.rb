# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class SearchController < ApplicationController
        def show
          if !params[:name]
            raise InvalidParams, 'missing key name and value'
          elsif params[:name] == ''
            raise InvalidParams, 'you must specify a value for name'
          else
            render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
          end
        end
      end
    end
  end
end
