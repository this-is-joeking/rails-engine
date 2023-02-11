# frozen_string_literal: true
# require 'rails_helper'

# RSpec.describe 'revenue merchants queries' do
#   it 'returns top # merchants by revenue' do
#     create_list(:merchant, 3)
#     get '/api/v1/revenue/merchants?quantity=3'

#     expect(response).to be_successful

#     body = JSON.parse(response.body, symbolize_names: true)

#     expect(body).to have_key(:data)
#     expect(body[:data]).to be_a Array
#     expect(body[:data].length).to eq(3)
#     body[:data].each do |merchant|
#       expect(merchant[:id]).to be_a(String)
#       expect(merchant[:id].to_i).to be_a(Integer)
#       expect(merchant[:type]).to eq('merchant_name_revenue')
#       expect(merchant[:attributes][:name]).to be_a(String)
#       expect(merchant[:attributes][:revenue]).to be_a(Float)
#     end
#   end
# end
