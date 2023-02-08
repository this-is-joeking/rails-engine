require 'rails_helper'

RSpec.describe 'find all merchants' do
  it 'returns all matching merchants' do
    Merchant.create!(name: 'Ring World')
    Merchant.create!(name: 'Turing')

    get '/api/v1/merchants/find_all?name=ring'

    expect(response).to be_successful

    merchants_data = JSON.parse(response.body, symbolize_names: true)

    expect(merchants_data).to have_key(:data)
    merchants_data[:data].each do |merchant|
      expect(merchant.keys.sort).to eq([:id, :type, :attributes].sort)
      expect(merchant[:id]).to be_a String
      expect(merchant[:type]).to eq 'merchant'
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String
    end
    
  end
  
end