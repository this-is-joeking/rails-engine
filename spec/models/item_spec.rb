require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '#find_item' do
    it 'returns the first single item in case insensitive search' do
      merch_id = create(:merchant).id
      item = Item.create!(name: 'Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      expect(Item.find_item('plumbus')).to eq(item)
    end

    it 'returns first in alphabetical order if there are multiple matches' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'PlumbusLite', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item2 = Item.create!(name: 'XL Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item4 = Item.create!(name: 'A Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      expect(Item.find_item('plumbus')).to eq(item4)
    end

    it 'returns nil if query does not have any matches' do
      merch_id = create(:merchant).id
      create_list(:item, 20)
      expect(Item.find_item('plumbus')).to eq(nil)
    end

    it 'also searches in the description field' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'Thing 1', description: 'does something plumbus related', unit_price: 12.99, merchant_id: merch_id)
      item2 = Item.create!(name: 'Thing 2', description: 'does something plumbus related', unit_price: 12.99, merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus Thing', description: 'does something plumbus related', unit_price: 12.99, merchant_id: merch_id)
      item4 = Item.create!(name: 'Another thing', description: 'does something plumbus related', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      expect(Item.find_item('plumbus')).to eq(item4)
    end
  end
end
