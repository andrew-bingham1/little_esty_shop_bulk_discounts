class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidaysBuilder.next_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.create(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else 
      flash.notice = "Please fill in all fields properly."
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @discount = BulkDiscount.find(params[:id])
    if @discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@discount.merchant_id, @discount)
    else
      flash.notice = "Please fill in all fields properly."
      redirect_to edit_merchant_bulk_discount_path(@discount.merchant_id, @discount)
    end
  end

  private
  def bulk_discount_params
    params.permit(:name, :discount, :threshold)
  end
end