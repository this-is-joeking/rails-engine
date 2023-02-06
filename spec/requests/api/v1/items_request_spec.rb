require 'rails_helper'

RSpec.describe 'Items API requests' do
  describe 'get all items' do
    it 'returns all items in JSON:API format' do
      create_list(:merchant, 5)
      create_list(:item, 10)


      get '/api/v1/items'

      expect(response).to be_successful

      items_data = JSON.parse(response.body, symbolize_names: true)

      expect(items_data).to have_key(:data)

      items_data[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a String
        expect(item[:id].to_i).to be_a Integer

        expect(item).to have_key(:attributes)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a String

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a String

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a Float
      end
    end
  end

  describe 'get one item' do
    it 'returns one item in the appropriate format' do
      create_list(:merchant, 5)
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)

      item = item_data[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer

      expect(item).to have_key(:attributes)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float
    end
  end
end