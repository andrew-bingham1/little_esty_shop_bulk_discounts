class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def find_invoice_item_discount(merchant)
    BulkDiscount.joins(:invoice_items)
                .where("items.merchant_id = ? AND invoice_items.id = ?", merchant.id, self.id)
                .where("invoice_items.quantity >= bulk_discounts.threshold")
                .order("bulk_discounts.threshold DESC")
                .first
  end
end
