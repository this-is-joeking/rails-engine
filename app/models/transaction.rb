# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :invoice

  validates_presence_of :credit_card_number, :result
end
