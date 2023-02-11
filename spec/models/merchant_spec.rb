# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe '#find_all_by_name()' do
    it 'returns an array of merchants with case insensitive match to the argument passed' do
      merchant1 = Merchant.create!(name: 'European Boutique')
      merchant2 = Merchant.create!(name: 'Best of Europe')
      merchant3 = Merchant.create!(name: 'Exhcnage euros')
      merchant4 = Merchant.create!(name: 'Not included in results')
      merchant5 = Merchant.create!(name: 'Neurology-r-us')

      resutls = Merchant.find_all_by_name('EURO').sort

      expect(resutls).to eq([merchant1, merchant2, merchant3, merchant5].sort)
    end

    it 'returns empty array if no results' do
      expect(Merchant.find_all_by_name('EURO')).to eq([])
    end
  end
end
