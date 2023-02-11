# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    unit_price { Faker::Number.within(range: 1.00..999.99) }
    merchant_id { Faker::Number.within(range: Merchant.minimum(:id)..Merchant.maximum(:id)) }
  end
end
