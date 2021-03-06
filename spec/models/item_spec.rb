require "rails_helper"

RSpec.describe Item do
  # describe "validations" do
  #   it { should validate_presence_of :name}
  #   it { should validate_presence_of :description}
  #   it { should validate_presence_of :unit_price}
  #   it { should validate_presence_of :merchant_id}
  # end
  #
  # describe "relationships" do
  #   it {should belong_to :merchant}
  # end

  describe "class methods" do
    it "#find_items for matching name or description" do

      merchant = Merchant.create(name: "Turing")
      item1 = create(:item, merchant_id: merchant.id, name: "titanium rings")
      item2 = create(:item, merchant_id: merchant.id, name: "Ring")
      item3 = create(:item, merchant_id: merchant.id, description: "This is a ring")
      item4 = create(:item, merchant_id: merchant.id, description: "titanium Rings")

      resulting_items = Item.find_items("ring")

      expect(resulting_items.length).to eq(4)
      expect(resulting_items).to include(item1)
      expect(resulting_items).to include(item2)
      expect(resulting_items).to include(item3)
      expect(resulting_items).to include(item4)
    end

    it "#find_items for matching name or description" do

      merchant = Merchant.create(name: "Turing")
      item1 = create(:item, merchant_id: merchant.id, name: "titanium rings")
      item2 = create(:item, merchant_id: merchant.id, name: "Ring")
      item3 = create(:item, merchant_id: merchant.id, description: "This is a ring")
      item4 = create(:item, merchant_id: merchant.id, description: "titanium Rings")

      resulting_items = Item.find_items("Ring")

      expect(resulting_items.length).to eq(4)
      expect(resulting_items).to include(item4)

    end

    it "#find_items_with_min" do
      merchant = Merchant.create(name: "Turing")
      item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
      item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
      item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
      item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

      resulting_items = Item.find_items_with_min(5)
      expect(resulting_items).to eq([item3, item4])
    end

    it "#find_items_with_max" do
      merchant = Merchant.create(name: "Turing")
      item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
      item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
      item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
      item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

      resulting_items = Item.find_items_with_max(20)
      expect(resulting_items).to eq([item1, item2, item3])
    end

    it "#find_items_with_minmax" do
      merchant = Merchant.create(name: "Turing")
      item1 = create(:item, merchant_id: merchant.id, unit_price: 1.00)
      item2 = create(:item, merchant_id: merchant.id, unit_price: 5.00)
      item3 = create(:item, merchant_id: merchant.id, unit_price: 10.00)
      item4 = create(:item, merchant_id: merchant.id, unit_price: 20.00)

      resulting_items = Item.find_items_with_minmax(5, 20)
      expect(resulting_items).to eq([item3])
    end
  end
  describe "instance method" do
    # it "#check_params" do
    #   item = create(:item)
    #   good_params = ({
    #                   "name": "Laptop",
    #                   "description": "World's Greatest Laptop",
    #                   "unit_price": 100.99,
    #                   "merchant_id": 10
    #                 })
    #   bad_params = ({
    #                   "name": "Laptop",
    #                   "description": "World's Greatest Laptop",
    #                   "unit_price": "100.99",
    #                   "merchant_id": 10
    #                 })
    #   result1 = item.check_params(good_params)
    #   result2 = item.check_params(bad_params)
    #   require "pry"; binding.pry
    #
    # end
  end
end
