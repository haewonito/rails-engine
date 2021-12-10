class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
    else
      render json: {errors: {details: "An item with this id does not exist."}}, status: 404
    end
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: {errors: {details: "One or more attributes are invalid or missing."}}, status: 400
    end
  end

  # def update
  #   if Merchant.exists?(item_params[:merchant_id])
  #     new_item = Item.update(params[:id], item_params)
  #     render json: ItemSerializer.new(new_item)
  #   else
  #     render json: {errors: {details: "A merchant with this id does not exist."}}, status: 400
  #   end
  # end

  # def update
  #   item = Item.find(params[:id])
  #   new_item = item.update(item_params)
  #   if new_item.save
  #     render json: ItemSerializer.new(new_item)
  #   else
  #     render json: {errors: {details: "A merchant with this id does not exist."}}, status: 400
  #   end
  # end
  def update
    if item_params[:merchant_id] != nil
      if Merchant.exists?(item_params[:merchant_id])
        new_item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(new_item)
      else
        render json: {errors: {details: "A merchant with this id does not exist."}}, status: 400
      end
    else
      new_item = Item.update(params[:id], item_params)
      render json: ItemSerializer.new(new_item)
    end
  end

  def destroy
     item = Item.find(params[:id])
     item.destroy
   end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
