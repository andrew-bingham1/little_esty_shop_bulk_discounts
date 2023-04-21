require 'rails_helper'

RSpec.describe "Bulk Discount Show Page", type: :feature do
  describe 'Show Page' do
    before (:each) do
      @merchant_1 = Merchant.create!(name: "All the Things")
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "10% off 10 or more", threshold: 10, discount: 0.10)
      @merchant_2 = Merchant.create!(name: "Junk and Stuff")
      @discount_2 = @merchant_2.bulk_discounts.create!(name: "20% off 20 or more", threshold: 20, discount: 0.20)
      @discount_3 = @merchant_1.bulk_discounts.create!(name: "30% off 30 or more", threshold: 30, discount: 0.30)
    end

    it 'exits' do
      visit merchant_bulk_discount_path(@merchant_1, @discount_1)
    end

    it 'displays the bulk discount name, threshold, and discount' do
      visit merchant_bulk_discount_path(@merchant_1, @discount_1)

      expect(page).to have_content(@discount_1.name)
      expect(page).to have_content(@discount_1.threshold)
      expect(page).to have_content("10%")

      expect(page).to_not have_content(@discount_2.name)
      expect(page).to_not have_content(@discount_2.threshold)
      expect(page).to_not have_content("20%")
      expect(page).to_not have_content(@discount_3.name)
      expect(page).to_not have_content(@discount_3.threshold)
      expect(page).to_not have_content("30%")
    end
  end
end