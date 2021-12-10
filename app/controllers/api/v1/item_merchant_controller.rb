class Api::V1::ItemMerchantController < ApplicationController

  def index
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      merchant = item.merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: {errors: {details: "An item with this id does not exist."}}, status: 404
    end
  end

end
