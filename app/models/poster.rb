class Poster < ApplicationRecord
  def self.created_at_desc
    order(created_at: :desc)
  end
  
  def self.min_price(min_value)
    where('price > ?', min_value)
  end
end