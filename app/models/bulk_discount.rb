class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant

  validates_presence_of :name
  validates_numericality_of :discount, :threshold
 
end

