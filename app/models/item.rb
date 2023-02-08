class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.find_item(query)
    Item.where('lower(name) like ?', "%#{query.downcase}%")
        .or(Item.where('lower(description) like ?', "%#{query.downcase}%"))
        .order(:name).first
  end
end
