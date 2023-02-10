require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'get all merchants' do
    it 'sends all the merchants' do
      create_list(:merchant, 5)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants).to have_key(:data)

      merchants[:data].each do |merchant|
        expect(merchant.keys.sort).to eq(%i[id type attributes].sort)
        expect(merchant[:id]).to be_a String
        expect(merchant[:type]).to eq('merchant')
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a String
      end
    end
  end

  describe 'get one merchant' do
    it 'sends 1 merchant' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant_data = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_data).to have_key(:data)

      merchant = merchant_data[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a String
      expect(merchant[:id].to_i).to be_a Integer
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String
    end

    it 'has a 404 status if given an invalid merchant id' do
      get '/api/v1/merchants/1'

      expect(response).to have_http_status(404)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:errors)
      expect(body).to_not have_key(:data)
      expect(body[:errors]).to eq(["Couldn't find Merchant with 'id'=1"])
      expect(body[:message]).to eq("your query could not be completed")
    end
  end

  describe 'get all items for a merchant' do
    it 'sends all items for given merchant' do
      id = create(:merchant).id
      create_list(:item, 10)

      create_list(:merchant, 5)
      create_list(:item, 10)

      get "/api/v1/merchants/#{id}/items"

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

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a Integer
        expect(item[:attributes][:merchant_id]).to eq(id)
      end
    end

    it 'returns a status of 404 if given invalid merchant id' do
      get '/api/v1/merchants/1/items'

      expect(response).to have_http_status(404)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to have_key(:errors)
      expect(body).to_not have_key(:data)
      expect(body[:errors]).to eq(["Couldn't find Merchant with 'id'=1"])
      expect(body[:message]).to eq("your query could not be completed")
    end
  end
end
