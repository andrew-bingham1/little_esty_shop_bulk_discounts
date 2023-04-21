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

      visit merchant_bulk_discount_path(@merchant_1, @discount_3)

      visit merchant_bulk_discount_path(@merchant_2, @discount_2)
    end

    it 'displays the bulk discount name, threshold, and discount' do
      visit merchant_bulk_discount_path(@merchant_1, @discount_1)

      within("#discount_info") do
        expect(page).to have_content(@discount_1.name)
        expect(page).to have_content(@discount_1.threshold)
        expect(page).to have_content("10%")
      end

      expect(page).to_not have_content(@discount_2.name)
      expect(page).to_not have_content(@discount_2.threshold)
      expect(page).to_not have_content("20%")

      expect(page).to_not have_content(@discount_3.name)
      expect(page).to_not have_content(@discount_3.threshold)
      expect(page).to_not have_content("30%")

      visit merchant_bulk_discount_path(@merchant_2, @discount_2)

      within("#discount_info") do
        expect(page).to have_content(@discount_2.name)
        expect(page).to have_content(@discount_2.threshold)
        expect(page).to have_content("20%")
      end

      expect(page).to_not have_content(@discount_1.name)
      expect(page).to_not have_content(@discount_1.threshold)
      expect(page).to_not have_content("10%")

      expect(page).to_not have_content(@discount_3.name)
      expect(page).to_not have_content(@discount_3.threshold)
      expect(page).to_not have_content("30%")
    end
  end

  describe 'User Story 5: Merchant Bulk Discount Edit' do
    before (:each) do
      @merchant_1 = Merchant.create!(name: "All the Things")
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "10% off 10 or more", threshold: 10, discount: 0.10)
      @merchant_2 = Merchant.create!(name: "Junk and Stuff")
      @discount_2 = @merchant_2.bulk_discounts.create!(name: "20% off 20 or more", threshold: 20, discount: 0.20)
      @discount_3 = @merchant_1.bulk_discounts.create!(name: "30% off 30 or more", threshold: 30, discount: 0.30)
    end

    it 'has a link to edit the bulk discount' do
      visit merchant_bulk_discount_path(@merchant_1, @discount_1)

      within("#discount_info") do
        expect(page).to have_link("Edit Discount")
      end

      visit merchant_bulk_discount_path(@merchant_2, @discount_2)

      within("#discount_info") do
        expect(page).to have_link("Edit Discount")
      end
    end

    it 'When I click this link then I am taken to a new page with a form to edit the discount' do
      visit merchant_bulk_discount_path(@merchant_1, @discount_1)

      click_link("Edit Discount")

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @discount_1))
    end

    it 'I see that the discounts current attributes are pre-poluated in the form' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      within("#update_form") do 
        expect(page).to have_field("Name", with: @discount_1.name)
        expect(page).to have_field("Threshold", with: @discount_1.threshold)
        expect(page).to have_field("Discount", with: @discount_1.discount)
      end
    end

    it 'When I change any/all of the information and click submit then I am redirected to the bulk discount show page' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      within("#update_form") do 
        fill_in("Name", with: "50% off 10 or more")
        fill_in("Threshold", with: 10)
        fill_in("Discount", with: 0.50)
        click_button("Update Discount")
      end

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))
    end

    it 'I see that the discount attributes have been updated' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      within("#update_form") do 
        fill_in("Name", with: "50% off 10 or more")
        fill_in("Threshold", with: 10)
        fill_in("Discount", with: 0.50)
        click_button("Update Discount")
      end

      @discount_1.reload
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))

      within("#discount_info") do
        expect(page).to have_content(@discount_1.name)
        expect(page).to have_content(@discount_1.threshold)
        expect(page).to have_content("50%")
      end
    end

    it 'I see a message if I fail to fill in all fields' do
      visit edit_merchant_bulk_discount_path(@merchant_1, @discount_1)

      fill_in("Name", with: "")

      click_button("Update Discount")

      expect(page).to have_content("Please fill in all fields properly.")
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @discount_1))
    end
  end
end


