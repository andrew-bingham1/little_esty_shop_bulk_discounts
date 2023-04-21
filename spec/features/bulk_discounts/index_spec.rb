require 'rails_helper'

RSpec.describe "Bulk Discount Index Page", type: :feature do
  describe "User Story 1" do
    before (:each) do
      @merchant_1 = Merchant.create!(name: "All the Things")
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "10% off 10 or more", threshold: 10, discount: 0.10)
      @merchant_2 = Merchant.create!(name: "Junk and Stuff")
      @discount_2 = @merchant_2.bulk_discounts.create!(name: "20% off 20 or more", threshold: 20, discount: 0.20)
      @discount_3 = @merchant_1.bulk_discounts.create!(name: "30% off 30 or more", threshold: 30, discount: 0.30)
    end

    it "When I visit my merchant dashboard then I see a link to view all my discounts" do
      visit merchant_dashboard_index_path(@merchant_1)

      within("#nav_bar") do
        expect(page).to have_link("Discounts")
      end
    end

    it "When I click this link then I am taken to my bulk discounts index page" do
      visit merchant_dashboard_index_path(@merchant_1)

      click_link ("Discounts")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
    end

    it "Where I see all of my bulk discounts including their percentage discount and quantity thresholds" do
      visit merchant_bulk_discounts_path(@merchant_1)

      within("##{@discount_1.id}") do
        expect(page).to have_content(@discount_1.name)
        expect(page).to have_content(@discount_1.threshold)
        expect(page).to have_content("10%")
      end

      within("##{@discount_3.id}") do
        expect(page).to have_content(@discount_3.name)
        expect(page).to have_content(@discount_3.threshold)
        expect(page).to have_content("30%")
      end

      expect(page).to_not have_content(@discount_2.name)
      expect(page).to_not have_content(@discount_2.threshold)
      expect(page).to_not have_content("20%")
    end

    it "And each bulk discount listed includes a link to its show page" do
      visit merchant_bulk_discounts_path(@merchant_1)

      within("##{@discount_1.id}") do
        expect(page).to have_link("#{@discount_1.name}")
      end

      within("##{@discount_3.id}") do
        expect(page).to have_link("#{@discount_3.name}")
      end
    end

    it "When I click this link then I am taken to my bulk discount show page" do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link ("#{@discount_1.name}")

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))
    end
  end
end



