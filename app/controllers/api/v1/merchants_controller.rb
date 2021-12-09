class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    else
      render json: {errors: {details: "A merchant with this id does not exist."}}, status: 404
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :id)
  end

end
