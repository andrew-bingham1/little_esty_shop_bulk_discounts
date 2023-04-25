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

  def discounted_merchant_invoice_revenue(merchant)
    merchant_discounted_revenue = invoice_items.joins(:item, :bulk_discounts)
                                               .select("invoice_items.*,((invoice_items.unit_price * invoice_items.quantity) * MAX(bulk_discounts.discount)) AS discounted_revenue")
                                               .where("invoice_items.quantity >= bulk_discounts.threshold AND items.merchant_id = ?", merchant)
                                               .group(:id)

    merchant_invoice_revenue(merchant) - merchant_discounted_revenue.sum(&:discounted_revenue)
  end

  def total_discounted_revenue
    total_discounted_revenue = invoice_items.joins(:item, :bulk_discounts)
                                            .select("invoice_items.*,((invoice_items.unit_price * invoice_items.quantity) * MAX(bulk_discounts.discount)) AS discounted_revenue")
                                            .where("invoice_items.quantity >= bulk_discounts.threshold")
                                            .group(:id)

    total_revenue - total_discounted_revenue.sum(&:discounted_revenue)
  end

end
