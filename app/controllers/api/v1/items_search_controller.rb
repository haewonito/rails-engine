class Api::V1::ItemsSearchController < ApplicationController
  def index
    items = Item.find_items(params[:name])
    if items.length > 0
      render json: ItemSerializer.new(items)
    else
      # render :nothing => true, :status => 204
      render json: { "data": []}
    end

  end
end
