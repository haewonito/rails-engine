class Api::V1::ItemsController < ApplicationController

  def index
    require "pry"; binding.pry
    # render json: Item.find
  end

end
