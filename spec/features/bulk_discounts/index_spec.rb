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

  describe "User Story 2" do
    before (:each) do
      @merchant_1 = Merchant.create!(name: "All the Things")
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "10% off 10 or more", threshold: 10, discount: 0.10)
      @merchant_2 = Merchant.create!(name: "Junk and Stuff")
      @discount_2 = @merchant_2.bulk_discounts.create!(name: "20% off 20 or more", threshold: 20, discount: 0.20)
      @discount_3 = @merchant_1.bulk_discounts.create!(name: "30% off 30 or more", threshold: 30, discount: 0.30)
    end

    it "When I visit my bulk discounts index page then I see a link to create a new discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      within("#discounts") do
        expect(page).to have_link("New Discount")
      end

      visit merchant_bulk_discounts_path(@merchant_2)

      within("#discounts") do
        expect(page).to have_link("New Discount")
      end
    end

    it "When I click this link then I am taken to a new page where I see a form to add a new bulk discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link ("New Discount")

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

      visit merchant_bulk_discounts_path(@merchant_2)

      click_link ("New Discount")

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_2))
    end

    it "When I fill in the form with valid data then I am redirected back to the bulk discount index and I see my new bulk discount listed" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      fill_in "Name", with: "40% off 40 or more"
      fill_in "Threshold", with: 40
      fill_in "Discount", with: 0.40

      click_button "Submit"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

      within ("#discounts") do
        expect(page).to have_content("40% off 40 or more")
        expect(page).to have_content("40")
        expect(page).to have_content("40%")
      end

      visit new_merchant_bulk_discount_path(@merchant_2)

      fill_in "Name", with: "40% off 40 or more"
      fill_in "Threshold", with: 40
      fill_in "Discount", with: 0.40

      click_button "Submit"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_2))

      within ("#discounts") do
        expect(page).to have_content("40% off 40 or more")
        expect(page).to have_content("40")
        expect(page).to have_content("40%")
      end
    end

    it "I am given an alert if all fields are not filled in" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      fill_in "Name", with: ""
      fill_in "Threshold", with: 40
      fill_in "Discount", with: 0.40

      click_button "Submit"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      expect(page).to have_content("Please fill in all fields properly.")
    end

    it "I am given an alert if the threshold is not a number" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      fill_in "Name", with: "Big Discount"
      fill_in "Threshold", with: "forty"
      fill_in "Discount", with: 0.40

      click_button "Submit"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      expect(page).to have_content("Please fill in all fields properly.")
    end

    it "I am given an alert if the discount is not a number" do
      visit new_merchant_bulk_discount_path(@merchant_1)

      fill_in "Name", with: "Big Discount"
      fill_in "Threshold", with: 40
      fill_in "Discount", with: "forty"

      click_button "Submit"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      expect(page).to have_content("Please fill in all fields properly.")
    end
  end

  describe "User Story 3" do
    before (:each) do
      @merchant_1 = Merchant.create!(name: "All the Things")
      @discount_1 = @merchant_1.bulk_discounts.create!(name: "10% off 10 or more", threshold: 10, discount: 0.10)
      @merchant_2 = Merchant.create!(name: "Junk and Stuff")
      @discount_2 = @merchant_2.bulk_discounts.create!(name: "20% off 20 or more", threshold: 20, discount: 0.20)
      @discount_3 = @merchant_1.bulk_discounts.create!(name: "30% off 30 or more", threshold: 30, discount: 0.30)
    end
    
    it "When I visit my bulk discounts index page then next to each bulk discount I see a link to delete it" do
      visit merchant_bulk_discounts_path(@merchant_1)

      within("##{@discount_1.id}") do
        expect(page).to have_link("Delete Discount")
      end

      within("##{@discount_3.id}") do
        expect(page).to have_link("Delete Discount")
      end

      visit merchant_bulk_discounts_path(@merchant_2)

      within("##{@discount_2.id}") do
        expect(page).to have_link("Delete Discount")
      end
    end

    it "When I click this link then I am redirected back to the bulk discounts index page and I no longer see the discount listed" do
      visit merchant_bulk_discounts_path(@merchant_1)

      within("#discounts") do
        expect(page).to have_content("10% off 10 or more")
        expect(page).to have_content("30% off 30 or more")
      end
      
      within("##{@discount_1.id}") do
        click_link("Delete Discount")
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      
      within("#discounts") do
        expect(page).to have_content(@discount_3.name)
        expect(page).to_not have_content(@discount_1.name)
      end
    end
  end
end




