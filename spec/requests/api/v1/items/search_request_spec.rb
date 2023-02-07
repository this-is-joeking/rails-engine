require 'rails_helper'

RSpec.describe 'Item search requests' do
  describe 'search by keyword' do
    it 'returns closest match in alphabetical order' do
      merch_id = create(:merchant).id
      item = Item.create!(name: 'Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      get '/api/v1/items/find?name=plumbus'

      expect(response).to be_successful
    end
  end
end