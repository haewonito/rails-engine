class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_items(search_word)
    name_match = where("name ILIKE ?", "%#{search_word}%")
    description_match = where("description ILIKE ?", "%#{search_word}%")

    final_array = (name_match + description_match).flatten
  end

  def self.find_items_with_min(min_price)
    where( "unit_price > ?", "#{min_price}")
  end

  def self.find_items_with_max(max_price)
    where( "unit_price < ?", "#{max_price}")
  end

  def self.find_items_with_minmax(min_price, max_price)
    where( "unit_price > ?", "#{min_price}")
    .where( "unit_price < ?", "#{max_price}")
  end

end
