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

  it "sends an item by the id" do
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
  it "can create a new item" do
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
    # expect(response).to be_successful
    # expect(created_item[:data][:id]).to eq(item_params[:name])
    # expect(created_item[:data][:attributes][:name]).to eq(item_params[:name])
    # expect(created_item[:data][:attributes][:description]).to eq(item_params[:description])
    # expect(created_item[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])
    # expect(created_item[:data][:attributes][:merchant_id]).to eq(item_params[:merchant_id])
  end

  xit "can update an existing book" do
    id = create(:book).id
    previous_name = Book.last.title
    book_params = { title: "Charlotte's Web" }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v1/books/#{id}", headers: headers, params: JSON.generate({book: book_params})
    book = Book.find_by(id: id)

    expect(response).to be_successful
    expect(book.title).to_not eq(previous_name)
    expect(book.title).to eq("Charlotte's Web")
  end

  xit "can destroy an book" do
    book = create(:book)

    expect(Book.count).to eq(1)

    delete "/api/v1/books/#{book.id}"

    expect(response).to be_successful
    expect(Book.count).to eq(0)
    expect{Book.find(book.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
