require "rails_helper"

RSpec.describe Item do
  describe "validations" do
    xit { should validate_presence_of :name}
  end

  describe "relationships" do
    xit {should have_many :items}
  end

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
  end
end
