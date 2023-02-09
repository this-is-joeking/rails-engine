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
      expect(item_data[:data].keys.sort).to eq(%i[id type attributes].sort)

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

    it 'returns 400 if you do not specify the value of name' do
      merch_id = create(:merchant).id
      create_list(:item, 20)

      get '/api/v1/items/find?name='

      expect(response).to have_http_status(400)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:errors)
      expect(body).to have_key(:message)
      expect(body[:message]).to eq('your query could not be completed')
      expect(body[:errors]).to be_a Array
      expect(body[:errors].first).to eq('your query could not be completed without a value for name')
    end

    it 'returns 400 status with message if no params are passed' do
      create(:merchant).id
      create_list(:item, 20)

      get '/api/v1/items/find'

      expect(response).to have_http_status(400)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:errors)
      expect(body).to have_key(:message)
      expect(body[:message]).to eq('your query could not be completed')
      expect(body[:errors]).to be_a Array
      expect(body[:errors].first).to eq('your query could not be completed without params')
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

  describe 'finding by min, max, or min and max price' do
    it 'finds an item meeting the min params given' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'Aarons Plumbus', description: 'does something', unit_price: 12.99,
                           merchant_id: merch_id)
      item2 = Item.create!(name: 'Thing 2', description: 'does something plumbus related', unit_price: 16.99,
                           merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus Thing', description: 'does something plumbus related', unit_price: 20.99,
                           merchant_id: merch_id)
      item4 = Item.create!(name: 'Another thing', description: 'does something plumbus related', unit_price: 24.99,
                           merchant_id: merch_id)

      get '/api/v1/items/find?min_price=12.99'

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)
      item = item_data[:data]

      expect(item.keys.sort).to eq(%i[id type attributes].sort)
      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to be_a String
      expect(item[:type]).to eq('item')

      expect(item[:attributes].keys.sort).to eq(%i[name description unit_price merchant_id].sort)
      expect(item[:attributes][:name]).to eq('Aarons Plumbus')
      expect(item[:attributes][:description]).to eq('does something')
      expect(item[:attributes][:unit_price]).to eq(12.99)
      expect(item[:attributes][:merchant_id]).to eq(merch_id)
    end

    it 'finds an item given max param' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'Thing 1', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item2 = Item.create!(name: 'Thing 2', description: 'does something plumbus related', unit_price: 16.99,
                           merchant_id: merch_id)
      item3 = Item.create!(name: 'Plumbus Thing', description: 'does something plumbus related', unit_price: 20.99,
                           merchant_id: merch_id)
      item4 = Item.create!(name: 'Another thing', description: 'does something plumbus related', unit_price: 24.99,
                           merchant_id: merch_id)

      get '/api/v1/items/find?max_price=12.99'

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)
      item = item_data[:data]

      expect(item.keys.sort).to eq(%i[id type attributes].sort)
      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to be_a String
      expect(item[:type]).to eq('item')

      expect(item[:attributes].keys.sort).to eq(%i[name description unit_price merchant_id].sort)
      expect(item[:attributes][:name]).to eq('Thing 1')
      expect(item[:attributes][:description]).to eq('does something')
      expect(item[:attributes][:unit_price]).to eq(12.99)
      expect(item[:attributes][:merchant_id]).to eq(merch_id)
    end

    it 'finds an item given min and max params' do
      merch_id = create(:merchant).id
      item1 = Item.create!(name: 'Thing 1', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      item2 = Item.create!(name: 'Thing 2', description: 'does something', unit_price: 16.99, merchant_id: merch_id)
      item3 = Item.create!(name: 'Aardvarks Shovel', description: 'does something', unit_price: 20.99,
                           merchant_id: merch_id)
      item4 = Item.create!(name: 'Another thing', description: 'does something cool', unit_price: 115.99,
                           merchant_id: merch_id)

      get '/api/v1/items/find?min_price=100&max_price=120'

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)
      item = item_data[:data]

      expect(item.keys.sort).to eq(%i[id type attributes].sort)
      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to be_a String
      expect(item[:type]).to eq('item')

      expect(item[:attributes].keys.sort).to eq(%i[name description unit_price merchant_id].sort)
      expect(item[:attributes][:name]).to eq('Another thing')
      expect(item[:attributes][:description]).to eq('does something cool')
      expect(item[:attributes][:unit_price]).to eq(115.99)
      expect(item[:attributes][:merchant_id]).to eq(merch_id)
    end

    it 'returns empty hash with data key if there are no results' do
      merch_id = create(:merchant).id
      create_list(:item, 20)

      get '/api/v1/items/find?min_price=1000&max_price=10000'

      expect(response).to be_successful

      empty_item_data = JSON.parse(response.body, symbolize_names: true)

      expect(empty_item_data).to have_key(:data)
      expect(empty_item_data[:data]).to eq({})
    end
  end
end
