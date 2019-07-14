class Item < ApplicationRecord
  validates :name, :amount, presence: true
  validates :amount, :sale, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
