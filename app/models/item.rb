class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.find_item_by_name(query)
    Item.where('lower(name) like ?', "%#{query.downcase}%")
        .or(Item.where('lower(description) like ?', "%#{query.downcase}%"))
        .order(:name).first
  end

  def self.find_item_by_price(min_max)
    range = (min_max[:min_price].to_f..min_max[:max_price].to_f) if min_max[:min_price] && min_max[:max_price]
  
    query = self.order(:name)
    query = query.where(unit_price: range) if range
    query = query.where('unit_price >= ?', min_max[:min_price]) if min_max[:min_price] && !min_max[:max_price]
    query = query.where('unit_price <= ?', min_max[:max_price]) if !min_max[:min_price] && min_max[:max_price]
    query.first
  end
end
