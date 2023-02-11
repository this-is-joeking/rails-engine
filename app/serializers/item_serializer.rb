# frozen_string_literal: true

class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id

  def self.no_item
    {
      "data": {}
    }
  end
end
