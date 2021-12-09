require 'rails_helper'

describe "Merchants_search API" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Turing")
    @merchant2 = Merchant.create(name: "Titanium Rings")
    @merchant3 = Merchant.create(name: "Rings That You Love")
  end

  it "happy path: sends the first search result" do

    get "/api/v1/merchants/find?name=Ring"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data][:id]).to eq(@merchant1.id.to_s)
    expect(merchant[:data][:attributes][:name]).to eq(@merchant1.name)

  end
end
