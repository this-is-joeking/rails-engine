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

  describe 'creating and deleting an item' do
    it 'creates a new item' do
      merch_id = create(:merchant).id
      item_params = {
                     "name": "New Item",
                     "description": "With a new description",
                     "unit_price": 100.99,
                     "merchant_id": merch_id
                    }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      new_item = Item.last

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(201)
      expect(new_item.name).to eq(item_params[:name])
      expect(new_item.description).to eq(item_params[:description])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
      expect(new_item.merchant_id).to eq(item_params[:merchant_id])
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

    it 'deletes an item' do
      merch_id = create(:merchant).id
      item = Item.create!(name: 'New Item', description: 'does something', unit_price: 12.99, merchant_id: merch_id)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.all).to eq([])
    end
  end

  describe 'updating an item' do
    it 'updates attributes of the given item' do
      merch_id = create(:merchant).id
      og_item = Item.create!(name: 'Item', description: 'does something', unit_price: 12.99, merchant_id: merch_id)

      item_params = {
        "name": "Updated Item",
        "description": "does something cool!",
        "unit_price": 5.99,
        "merchant_id": merch_id
       }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{og_item.id}", headers: headers, params: JSON.generate(item: item_params)
      
      expect(response).to be_successful
      
      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)
      
      item = item_data[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to eq(og_item.id)

      expect(item).to have_key(:attributes)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq("Updated Item")

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to eq("does something cool!")

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to eq(5.99)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(merch_id)
    end

    it 'returns a 404 status if trying to update with invalid merchant id' do
      merch_id = create(:merchant).id
      og_item = Item.create!(name: 'Item', description: 'does something', unit_price: 12.99, merchant_id: merch_id)

      item_params = {
        "name": "Updated Item",
        "description": "does something cool!",
        "unit_price": 5.99,
        "merchant_id": Merchant.maximum(:id) + 1
       }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{og_item.id}", headers: headers, params: JSON.generate(item: item_params)
      
      expect(response).to have_http_status(404)
    end
  end
end