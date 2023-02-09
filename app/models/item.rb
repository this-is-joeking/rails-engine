class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.find_item_by_name(query)
    Item.where('lower(name) like ?', "%#{query.downcase}%")
        .or(Item.where('lower(description) like ?', "%#{query.downcase}%"))
        .order(:name).first
  end

  def self.find_item_by_price(min_max)
    range = (min_max[:min_price].to_f..min_max[:max_price].to_f) if min_max[:min_price] && min_max[:max_price]

    query = order(:name)
    query = query.where(unit_price: range) if range
    query = query.where('unit_price >= ?', min_max[:min_price]) if min_max[:min_price] && !min_max[:max_price]
    query = query.where('unit_price <= ?', min_max[:max_price]) if !min_max[:min_price] && min_max[:max_price]
    query.first
  end

  def find_dependent_invoices

    # RUBY METHOD
    # dependent_invoices = []
    # invoices.distinct.each do |invoice|
    #   x = 0
    #   invoice.invoice_items.each do |ii|
    #     x += 1 if ii.item_id != self.id
    #   end
    #   dependent_invoices << invoice if x == 0
    # end
    # dependent_invoices

    # MOSTLY SQL METHOD
    Invoice.from("invoices JOIN invoice_items ON invoices.id = invoice_items.invoice_id").group(:id).having("SUM(CASE WHEN invoice_items.item_id != #{self.id} THEN 1 ELSE 0 END) = 0")

  end
end
