require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all items" do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to be 5

    items[:data].each do |item|
      expect(item[:id]).to be_an(String)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  xit "sends a merchant by the id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  xit "sends all items associated with a merchant by id" do
    #return 404 if the item is not found
    merchant = create(:merchant)
    # merchant_id = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant.id)


    get "/api/v1/merchants/#{merchant.id}/items"


    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].count).to be 3

    items[:data].each do |item|
      expect(item[:id]).to be_an(String)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end
end
