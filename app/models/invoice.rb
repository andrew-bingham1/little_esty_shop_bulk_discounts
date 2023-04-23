class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def merchant_invoice_revenue(merchant)
    invoice_items.joins(:item)
                 .where("items.merchant_id = ?", merchant)
                 .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def find_merchant_discount(merchant)
    BulkDiscount.joins(:invoices)
            .where("merchants.id = ?", merchant.id)
            .where("invoices.id = ?", self.id)
            .where("invoice_items.quantity >= bulk_discounts.threshold")
            .order("bulk_discounts.threshold DESC")
            .first
  end

  def discounted_invoice_revenue(merchant, bulk_discount)
    discount = (1 - bulk_discount.discount) 
    invoice_items.joins(:item)
                 .where("items.merchant_id = ?", merchant)
                 .sum("invoice_items.unit_price * invoice_items.quantity * #{discount}")
                 .round(2)
  end
end
