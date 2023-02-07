class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  has_one :merchant, through: :item
  enum status: { pending: 0, packaged: 1, shipped: 2 }
  validates_numericality_of :quantity, :unit_price

end