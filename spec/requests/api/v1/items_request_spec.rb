require 'rails_helper'

describe "Items API" do
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

  it "sends an item by the id: happy path" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    id = item.id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:type]).to eq("item")
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it "sends an item by the id: sad path" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    invalid_id = item.id + 1

    get "/api/v1/items/#{invalid_id}"
    expect(response).to have_http_status(404)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("An item with this id does not exist.")

  end
  it "can create a new item: Happy Path" do
    #sad path where attribute types are incorrect
    #edge cases where any attribute is missing
    merchant = create(:merchant)
    item_params = ({
                    "name": "Laptop",
                    "description": "World's Greatest Laptop",
                    "unit_price": 100.99,
                    "merchant_id": merchant.id
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end


  it "can create a new item: Edge case with missing attribute " do
    #sad path where attribute types are incorrect

    merchant = create(:merchant)
    bad_item_params = ({
                    "name": "Laptop",
                    "description": "World's Greatest Laptop",
                    "unit_price": "100.99",
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: bad_item_params)
    created_item = Item.last

    expect(response).to have_http_status(400)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("One or more attributes are invalid or missing.")

  end

  it "can update an existing item: Happy Path" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_id = item.id

    previous_name = Item.last.name
    item_params = { name: "Desk Top" }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: item_id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Desk Top")
  end

  it "can update an existing item: Sad Path" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_id = item.id
    bad_merchant_id = merchant.id + 1

    previous_name = Item.last.name
    item_params = { merchant_id: bad_merchant_id }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to have_http_status(400)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("A merchant with this id does not exist.")
  end

  it "can destroy an item" do
      # destroy the corresponding record (if found) and any associated data
      # destroy any invoice if this was the only item on an invoice
      # NOT return any JSON body at all, and should return a 204 HTTP status code
      # NOT utilize a Serializer (Rails will handle sending a 204 on its own if you just .destroy the object)
    customer = Customer.create(first_name: "Haewon", last_name: "Jeon")
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    # invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "sends a merchant associated with the item by id: happy path" do
    #return 404 if the item is not found
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"


    parsed_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(parsed_merchant[:data][:attributes][:name]).to be_a(String)
    expect(parsed_merchant[:data][:attributes][:name]).to eq(merchant.name)
  end

  it "sends a merchant associated with the item by id: sad path: item doesn't exist" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    invalid_item_id = item.id + 1

    get "/api/v1/items/#{invalid_item_id}/merchant"
    expect(response).to have_http_status(404)
    response_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(response_parsed[:errors][:details]).to eq("An item with this id does not exist.")

  end
end
