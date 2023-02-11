# frozen_string_literal: true

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
      attribute_keys = %i[name description unit_price merchant_id].sort
      items_data[:data].each do |item|
        expect(item.keys.sort).to eq(%i[id type attributes].sort)

        expect(item[:id]).to be_a String
        expect(item[:id].to_i).to be_a Integer
        expect(item[:type]).to eq('item')

        expect(item[:attributes].keys.sort).to eq(attribute_keys)
        expect(item[:attributes][:name]).to be_a String
        expect(item[:attributes][:description]).to be_a String
        expect(item[:attributes][:unit_price]).to be_a Float
        expect(item[:attributes][:merchant_id]).to be_a Integer
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

      expect(item.keys.sort).to eq(%i[id type attributes].sort)

      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to eq('item')

      attribute_keys = %i[name description unit_price merchant_id].sort

      expect(item[:attributes].keys.sort).to eq(attribute_keys)
      expect(item[:attributes][:name]).to be_a String
      expect(item[:attributes][:description]).to be_a String
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes][:merchant_id]).to be_a Integer
    end

    it 'returns a 404 message if given invalid id' do
      get '/api/v1/items/1'

      expect(response).to have_http_status(404)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.keys.sort).to eq(%i[message errors].sort)
      expect(body[:message]).to eq('your query could not be completed')
      expect(body[:errors]).to eq(["Couldn't find Item with 'id'=1"])
    end
  end

  describe 'creating an item' do
    it 'creates a new item' do
      merch_id = create(:merchant).id
      item_params = {
        "name": 'New Item',
        "description": 'With a new description',
        "unit_price": 100.99,
        "merchant_id": merch_id
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

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

      expect(item.keys.sort).to eq(%i[id type attributes].sort)

      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to be_a String
      expect(item[:type]).to eq('item')

      attribute_keys = %i[name description unit_price merchant_id].sort

      expect(item[:attributes].keys.sort).to eq(attribute_keys)
      expect(item[:attributes][:name]).to be_a String
      expect(item[:attributes][:description]).to be_a String
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes][:merchant_id]).to be_a Integer
    end

    it 'does not create an item if invalid merchant id is sent' do
      merch_id = create(:merchant).id
      item_params = {
        "name": 'New Item',
        "description": 'With a new description',
        "unit_price": 100.99,
        "merchant_id": Merchant.maximum(:id) + 1
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      new_item = Item.last

      expect(Item.last).to eq(nil)
      expect(response).to have_http_status(409)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body.keys.sort).to eq(%i[message errors].sort)
      expect(body[:message]).to eq('your query could not be completed')
      expect(body[:errors]).to eq(['Validation failed: Merchant must exist'])
    end

    it 'ignores any non-permitted attributes' do
      merch_id = create(:merchant).id
      item_params = {
        "name": 'New Item',
        "description": 'With a new description',
        "unit_price": 100.99,
        "merchant_id": merch_id,
        "dog_id": 1,
        "created_at": Time.now
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      new_item = Item.last

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)

      item = item_data[:data]

      expect(item.keys.sort).to eq(%i[id type attributes].sort)

      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to be_a Integer
      expect(item[:type]).to be_a String
      expect(item[:type]).to eq('item')

      attribute_keys = %i[name description unit_price merchant_id].sort

      expect(item[:attributes].keys.sort).to eq(attribute_keys)
      expect(item[:attributes][:name]).to be_a String
      expect(item[:attributes][:description]).to be_a String
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes][:merchant_id]).to be_a Integer
    end

    it 'returns an error if attributes are missing' do
      merch_id = create(:merchant).id
      item_params = {
        "name": 'New Item',
        "description": 'With a new description',
        "merchant_id": merch_id
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(409)
      expect(body).to have_key(:errors)
      expect(body).to_not have_key(:data)
      expect(body[:errors]).to eq(["Validation failed: Unit price can't be blank, Unit price is not a number"])
      expect(body[:message]).to eq('your query could not be completed')
    end
  end

  describe 'deleting an item' do
    it 'deletes invoice_items associated with it and any invoices where it is the only item' do
      merch_id = create(:merchant).id
      item = Item.create!(name: 'New Item', description: 'does something', unit_price: 12.99, merchant_id: merch_id)
      customer = Customer.create!(first_name: 'John', last_name: 'Doe')
      invoice = customer.invoices.create!(merchant_id: merch_id, status: 'in progress')
      ii = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 1, unit_price: 12.99)

      delete "/api/v1/items/#{item.id}"
      expect(response).to be_successful
      expect(response).to have_http_status(204)
      expect(InvoiceItem.all).to eq([])
      expect(Invoice.all).to eq([])
    end

    it 'sends a 404 if given invalid item id' do
      delete '/api/v1/items/1'

      expect(response).to have_http_status(404)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:errors)
      expect(body).to_not have_key(:data)
      expect(body[:errors]).to eq(["Couldn't find Item with 'id'=1"])
      expect(body[:message]).to eq('your query could not be completed')
    end
  end

  describe 'update an item' do
    it 'updates attributes of the given item' do
      merch_id = create(:merchant).id
      og_item = Item.create!(name: 'Item', description: 'does something', unit_price: 12.99, merchant_id: merch_id)

      item_params = {
        "name": 'Updated Item',
        "description": 'does something cool!',
        "unit_price": 5.99,
        "merchant_id": merch_id
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{og_item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(item_data).to have_key(:data)

      item = item_data[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String
      expect(item[:id].to_i).to eq(og_item.id)

      expect(item).to have_key(:attributes)

      attribute_keys = %i[name description unit_price merchant_id].sort

      expect(item[:attributes].keys.sort).to eq(attribute_keys)
      expect(item[:attributes][:name]).to eq('Updated Item')
      expect(item[:attributes][:description]).to eq('does something cool!')
      expect(item[:attributes][:unit_price]).to eq(5.99)
      expect(item[:attributes][:merchant_id]).to eq(merch_id)
    end

    it 'returns a 404 status if trying to update with invalid merchant id' do
      merch_id = create(:merchant).id
      og_item = Item.create!(name: 'Item', description: 'does something', unit_price: 12.99, merchant_id: merch_id)

      item_params = {
        "name": 'Updated Item',
        "description": 'does something cool!',
        "unit_price": 5.99,
        "merchant_id": Merchant.maximum(:id) + 1
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{og_item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(404)
    end
  end

  describe 'getting the merchant for a given item' do
    it 'returns the merchant associated with an item' do
      merch = create(:merchant)
      create_list(:merchant, 5)
      item = Item.create!(name: 'New Item', description: 'does something', unit_price: 12.99, merchant_id: merch.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_data).to have_key(:data)

      merchant = merchant_data[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a String
      expect(merchant[:id].to_i).to eq(merch.id)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq(merch.name)
    end

    it 'returns a 404 status if given invalid item id' do
      get '/api/v1/items/1/merchant'

      expect(response).to have_http_status(404)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:errors)
      expect(body).to_not have_key(:data)
      expect(body[:errors]).to eq(["Couldn't find Item with 'id'=1"])
      expect(body[:message]).to eq('your query could not be completed')
    end
  end
end
