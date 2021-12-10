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

  it "sends an error message if both name and price are sent" do
    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
    item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)


    get "/api/v1/items/find?name=whatever&max_price=10"

    expect(response).to have_http_status(400)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("Cannot have both name and price query.")
  end

  it "sends an error message if neither name or price is sent" do
    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
    item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

    get "/api/v1/items/find"

    expect(response).to have_http_status(400)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("Have to have either name or price for search.")
    end

  it "sends result with minimum price" do
    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
    item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

    get "/api/v1/items/find?min_price=5"
    expect(response).to be_successful
    response_parsed = JSON.parse(response.body, symbolize_names: true)

    response_parsed[:data].each do |item|
      expect(item[:attributes][:unit_price]).to be > 5
    end
  end

  it "sends result with maximum price" do
    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
    item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

    get "/api/v1/items/find?max_price=10"

    expect(response).to be_successful
    response_parsed = JSON.parse(response.body, symbolize_names: true)

    response_parsed[:data].each do |item|
      expect(item[:attributes][:unit_price]).to be < 10
    end
  end

  it "sends results with minimum and maximum price" do
    merchant = Merchant.create(name: "Turing")
    item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
    item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
    item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
    item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

    get "/api/v1/items/find?min_price=1&max_price=20"

    expect(response).to be_successful
    response_parsed = JSON.parse(response.body, symbolize_names: true)

    response_parsed[:data].each do |item|
      expect(item[:attributes][:unit_price]).to be < 20
      expect(item[:attributes][:unit_price]).to be > 1
    end
  end
end
