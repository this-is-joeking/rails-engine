require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :unit_price }
  end
  
  describe '#find_item_by_name()' do
    it 'returns the first single item in case insensitive search' do
      merch_id = create(:merchant).id
      item = Item.create!(name: 'Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      expect(Item.find_item_by_name('plumbus')).to eq(item)
    end

    it 'returns first in alphabetical order if there are multiple matches' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'PlumbusLite', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item2 = Item.create!(name: 'XL Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item4 = Item.create!(name: 'A Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      expect(Item.find_item_by_name('plumbus')).to eq(item4)
    end

    it 'returns nil if query does not have any matches' do
      merch_id = create(:merchant).id
      create_list(:item, 20)
      expect(Item.find_item_by_name('plumbus')).to eq(nil)
    end

    it 'also searches in the description field' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'Thing 1', description: 'does something plumbus related', unit_price: 12.99,
                           merchant_id: merch_id)
      item2 = Item.create!(name: 'Thing 2', description: 'does something plumbus related', unit_price: 12.99,
                           merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus Thing', description: 'does something plumbus related', unit_price: 12.99,
                           merchant_id: merch_id)
      item4 = Item.create!(name: 'Another thing', description: 'does something plumbus related', unit_price: 12.99,
                           merchant_id: merch_id)
      create_list(:item, 20)

      expect(Item.find_item_by_name('plumbus')).to eq(item4)
    end
  end

  describe '#find_item_by_price()' do
    it 'finds an item within the given price range' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'Thing 1', description: 'does something plumbus related', unit_price: 12.99,
                           merchant_id: merch_id)
      item2 = Item.create!(name: 'Thing 2', description: 'does something plumbus related', unit_price: 16.99,
                           merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus Thing', description: 'does something plumbus related', unit_price: 20.99,
                           merchant_id: merch_id)
      item4 = Item.create!(name: 'Another thing', description: 'does something plumbus related', unit_price: 24.99,
                           merchant_id: merch_id)

      result1 = Item.find_item_by_price({ min_price: '12.99' })
      result2 = Item.find_item_by_price({ max_price: '12.99' })
      result3 = Item.find_item_by_price({ min_price: '14.99', max_price: '19.99' })
      result4 = Item.find_item_by_price({ min_price: '140.99', max_price: '190.99' })

      expect(result1).to eq(item4)
      expect(result2).to eq(item1)
      expect(result3).to eq(item2)
      expect(result4).to eq(nil)
    end
  end
end
