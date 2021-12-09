require 'rails_helper'

describe "Items_search API" do

  it "happy path: sends search result matching name or description" do

    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, name: "titanium rings")
    item2 = create(:item, merchant_id: merchant.id, name: "Ring")
    item3 = create(:item, merchant_id: merchant.id, description: "This is a ring")
    item4 = create(:item, merchant_id: merchant.id, description: "titanium Rings")


    get "/api/v1/items/find?name=Ring"

    expect(response).to be_successful
    item_list = JSON.parse(response.body, symbolize_names: true)
    expect(item_list[:data]).to be_an(Array)
    expect(item_list[:data].length).to eq(4)
    expect(item_list[:data][0][:attributes][:name]).to eq("titanium rings")


  end

  it "sends empty array if there's no matching result" do

    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, name: "titanium rings")
    item2 = create(:item, merchant_id: merchant.id, name: "Ring")
    item3 = create(:item, merchant_id: merchant.id, description: "This is a ring")
    item4 = create(:item, merchant_id: merchant.id, description: "titanium Rings")


    get "/api/v1/items/find?name=nomatch"

    expect(response).to be_successful
    expect(response).to_not have_http_status(404)
    item_list = JSON.parse(response.body, symbolize_names: true)
  # require "pry"; binding.pry
    expect(item_list[:data]).to be_an(Array)
    expect(item_list[:data].length).to eq(0)
  end
end
