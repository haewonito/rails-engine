class Merchant < ApplicationRecord
  has_many :items

  def self.find_merchant(search_word)
    where("name ILIKE ?", "%#{search_word}")
    .order(name: :desc)
    .first

  end
end
