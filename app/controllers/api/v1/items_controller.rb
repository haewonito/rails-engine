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
    render json: ItemSerializer.new(item)
  end

  def update
    new_item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(new_item)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
