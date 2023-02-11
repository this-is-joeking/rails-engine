# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy

  validates_presence_of :name

  def self.find_all_by_name(query)
    Merchant.where('lower(name) like ?', "%#{query.downcase}%")
  end
end
