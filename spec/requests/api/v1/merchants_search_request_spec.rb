require 'rails_helper'

describe "Merchants_search API" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Turing")
    @merchant2 = Merchant.create(name: "Titanium Rings")
    @merchant3 = Merchant.create(name: "Rings That You Love")
  end

  it "happy path: sends the first search result - first in alphabetical order" do

    get "/api/v1/merchants/find?name=Ring"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data][:id]).to eq(@merchant3.id.to_s)
    expect(merchant[:data][:attributes][:name]).to eq(@merchant3.name)

  end

  it "happy path: sends the first search result: case insensitive" do

    get "/api/v1/merchants/find?name=ti"
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:id]).to eq(@merchant2.id.to_s)
    expect(merchant[:data][:attributes][:name]).to eq(@merchant2.name)
  end

  it "sad path? send no content if there's no result" do

    get "/api/v1/merchants/find?name=nomatch"
    expect(response.body).to be_empty
  end
end
