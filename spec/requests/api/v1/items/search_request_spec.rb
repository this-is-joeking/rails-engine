require 'rails_helper'

RSpec.describe 'Item search requests' do
  describe 'search by keyword' do
    it 'returns closest match in alphabetical order' do
      merch_id = create(:merchant).id
      item = Item.create!(name: 'Plumbus', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      create_list(:item, 20)

      get '/api/v1/items/find?name=plumbus'

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)
      expect(item_data[:data].keys.sort).to eq([:id, :type, :attributes].sort)

      item = item_data[:data]

      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to be_a String
      expect(item[:type]).to eq('item')

      attribute_keys = %i[name description unit_price merchant_id].sort

      expect(item[:attributes].keys.sort).to eq(attribute_keys)
      expect(item[:attributes][:name]).to eq('Plumbus')
      expect(item[:attributes][:description]).to eq('does something')
      expect(item[:attributes][:unit_price]).to eq(12.99)
      expect(item[:attributes][:merchant_id]).to eq(merch_id)
    end

    it 'returns 404 if you do not specify the value of name' do
      merch_id = create(:merchant).id
      create_list(:item, 20)

      get '/api/v1/items/find?name='

      expect(response).to have_http_status(404)
    end

    it 'returns data with an empty hash if it does not find any matches' do
      merch_id = create(:merchant).id
      create_list(:item, 20)

      get '/api/v1/items/find?name=NOMATCHESFORTHISQUERY'

      expect(response).to be_successful

      empty_item_data = JSON.parse(response.body, symbolize_names: true)
      
      expect(empty_item_data).to have_key(:data)
      expect(empty_item_data[:data]).to eq({})
    end
  end
end