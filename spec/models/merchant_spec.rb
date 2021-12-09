require "rails_helper"

RSpec.describe Merchant do
  describe "validations" do
    xit { should validate_presence_of :name}
  end

  describe "relationships" do
    xit {should have_many :items}
  end

  describe "class methods" do
    it "#find_merchant" do
      merchant1 = Merchant.create(name: "Turing")
      merchant2 = Merchant.create(name: "Titanium Rings")
      merchant3 = Merchant.create(name: "Rings That You Love")

      resulting_merchant = Merchant.find_merchant("ring")

      expect(resulting_merchant).to eq(merchant3)
    end
  end
end
