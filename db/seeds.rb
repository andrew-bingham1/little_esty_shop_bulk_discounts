InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all
BulkDiscount.destroy_all
system("rake import")
@bulk_discount_1 = BulkDiscount.create!(name: "5% off 10 or more", discount: 0.05, threshold: 10, merchant_id: 1)
@bulk_discount_2 = BulkDiscount.create!(name: "10% off 20 or more", discount: 0.10, threshold: 20, merchant_id: 1)