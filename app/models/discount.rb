class Discount < ApplicationRecord
  validates_presence_of :percentage, :quantity
  validates_inclusion_of :percentage, in: (1..100)

  belongs_to :merchant
end
