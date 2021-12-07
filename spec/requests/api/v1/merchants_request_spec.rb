require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to be 3

    merchants.each do |merchant|
      expect(merchant[:id]).to be_an(Integer)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it "sends a merchant by the id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:name]).to be_a(String)
  end

  it "sends all items associated with a merchant by id" do
    #return 404 if the item is not found
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}/items"
  end
end
