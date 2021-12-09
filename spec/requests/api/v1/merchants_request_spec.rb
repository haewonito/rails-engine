require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to be 3

    merchants[:data].each do |merchant|
      expect(merchant[:id]).to be_an(String)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "sends a merchant by the id: happy path" do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    merchant_parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_parsed[:data][:attributes][:name]).to be_a(String)
    expect(merchant_parsed[:data][:attributes][:name]).to eq(merchant.name)
  end

  it "sends a merchant by the id: sad path" do
    merchant = create(:merchant)
    invalid_id = merchant.id + 1

    get "/api/v1/merchants/#{invalid_id}"
    expect(response).to have_http_status(404)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("A merchant with this id does not exist.")

  end

  it "sends all items associated with a merchant by id" do
    #return 404 if the item is not found
    merchant = create(:merchant)
    # merchant_id = create(:merchant).id
    create_list(:item, 4, merchant_id: merchant.id)


    get "/api/v1/merchants/#{merchant.id}/items"


    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].count).to be 4

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
