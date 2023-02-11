module Api
  module V1
    module Items
      class SearchController < ApplicationController
        before_action :check_params, only: :show
        def show
          if params[:name].present?
            render_item(Item.find_item_by_name(params[:name]))
          elsif params[:min_price].present? || params[:max_price].present?
            render_item(Item.find_item_by_price(price_params))
          end
        end

        private

        def price_params
          params.permit(:min_price, :max_price)
        end

        def check_params
          invalid_params_combo? 
          invalid_params_values? 
          conflicting_price_values? 
          no_params? 
          empty_params?
        end
        
        def invalid_params_combo?
          has_name = params[:name].present?
          has_price = params[:max_price].present? || params[:min_price].present?
          if has_name && has_price
            raise InvalidParams.new('cannot send both price and name')
          end
        end

        def invalid_params_values?
          if params[:min_price].to_f.negative? || params[:max_price].to_f.negative?
            raise InvalidParams.new('price cannot be negative')
          end
        end

        def conflicting_price_values?
          if params[:min_price] && params[:max_price]
            if params[:min_price].to_f > params[:max_price].to_f
              raise InvalidParams.new('min price cannot be greater than max price')
            end
          else
            false
          end
        end

        def no_params?
          if params.keys & %w[min_price max_price name] == []
            raise InvalidParams.new('you must pass a valid param such as name, min_price, or max_price')
          end
        end  

        def empty_params?
          if params.values.include?('')
            raise InvalidParams.new('you must pass a value for params')
          end
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
