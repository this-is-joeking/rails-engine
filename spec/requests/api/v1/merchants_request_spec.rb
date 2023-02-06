require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'get all merchants' do
    it 'sends all the merchants' do
      create_list(:merchant, 5)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(merchants).to have_key(:data)
      # require 'pry'; binding.pry
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a String
        expect(merchant[:id].to_i).to be_a Integer
        expect(merchant).to have_key(:attributes)
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
  end
end