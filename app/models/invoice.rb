# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  # has_many :items, through: :invoice_items
  # has_many :transactions, dependent: :destroy
  # has_many :merchants, through: :items
  # enum status: { 'in progress' => 0, completed: 1, cancelled: 2 }
end
