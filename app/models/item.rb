class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_items(search_word)
    name_match = where("name ILIKE ?", "%#{search_word}%")
    description_match = where("description ILIKE ?", "%#{search_word}%")

    final_array = (name_match + description_match).flatten
  end
end
