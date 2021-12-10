class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.find_merchant(search_word)
    where("name ILIKE ?", "%#{search_word}%")
    .order(:name)
    .first
  end
end
