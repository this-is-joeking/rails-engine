# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
  end
end
