class Api::V1::ItemsSearchController < ApplicationController
#this is going to be very ugly.  hopefully i will have time to refactor
#can I just set variables even though they might be nil?

#if
  def index
    if (params[:name] and params[:max_price]) or (params[:name] and params[:min_price])
      render json: {errors: {details: "Cannot have both name and price query."}}, status: 400
    elsif !params[:name] and !params[:max_price] and !params[:min_price]
      render json: {errors: {details: "Have to have either name or price for search."}}, status: 400
    elsif params[:name]
      items = Item.find_items(params[:name])
      if items.length > 0
        render json: ItemSerializer.new(items)
      else
        # render :nothing => true, :status => 204
        render json: { "data": []}
      end
    else
      require "pry"; binding.pry
      if params(:min_price) and params(:max_price)
        items = Item.find_items_with_minmax(params(:min_price), params(:max_price))
        renter json: ItemSerializer.new(items)
      elsif params(:min_price) and !params(:max_price)
          items = Item.find_items_with_min(params(:min_price))
          renter json: ItemSerializer.new(items)
      elsif !params(:min_price) and params(:max_price)
          items = Item.find_items_with_max(params(:max_price))
          renter json: ItemSerializer.new(items)
      end
    end
  end
end
