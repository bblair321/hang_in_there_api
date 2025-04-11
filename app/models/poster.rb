class Poster < ApplicationRecord
  def self.min_price(min_value)
    where('price > ?', min_value)
  end
  
end