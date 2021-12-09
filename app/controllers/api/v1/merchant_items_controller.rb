class Api::V1::MerchantItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    render json: ItemSerializer.new(items)
# require "pry"; binding.pry
#     if Merchant.exists?(params[:merchant_id])
#       merchant = Merchant.find(params[:merchant_id])
#       items = merchant.items
#       render json: ItemSerializer.new(items)
#     else
#       render json: {errors: {details: "A merchant with this id does not exist."}}, status: 404
#     end
  end

end
