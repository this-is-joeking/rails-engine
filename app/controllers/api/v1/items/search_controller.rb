# frozen_string_literal: true

module Api
  module V1
    module Items
      class SearchController < ApplicationController
        before_action :check_params, only: :show
        def show
          if has_name?
            render_item(Item.find_item_by_name(params[:name]))
          elsif has_price?
            render_item(Item.find_item_by_price(price_params))
          end
        end

        private

        def price_params
          params.permit(:min_price, :max_price)
        end

        def check_params
          check_params_combo
          check_params_negative
          check_price_conflict
          check_params_present
          check_params_have_value
        end

        def check_params_combo
          return unless has_name? && has_price?

          raise InvalidParams, 'cannot send both price and name'
        end

        def check_params_negative
          return unless params[:min_price].to_f.negative? || params[:max_price].to_f.negative?

          raise InvalidParams, 'price cannot be negative'
        end

        def check_price_conflict
          if (params[:min_price] && params[:max_price]) && (params[:min_price].to_f > params[:max_price].to_f)
            raise InvalidParams, 'min price cannot be greater than max price'
          end
        end

        def check_params_present
          return unless params.keys & %w[min_price max_price name] == []

          raise InvalidParams, 'you must pass a valid param such as name, min_price, or max_price'
        end

        def check_params_have_value
          return unless params.values.include?('')

          raise InvalidParams, 'you must pass a value for params'
        end

        def has_price?
          params[:max_price].present? || params[:min_price].present?
        end

        def has_name?
          params[:name].present?
        end

        def render_item(item)
          if item.nil?
            render json: ItemSerializer.no_item
          else
            render json: ItemSerializer.new(item)
          end
        end
      end
    end
  end
end
