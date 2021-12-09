class Api::V1::MerchantSearchController < ApplicationController
  def index
    merchant = Merchant.find_merchant(params[:name])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      # render :nothing => true, :status => 204
      head :no_content
    end

  end
end
