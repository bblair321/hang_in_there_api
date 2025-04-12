class Poster < ApplicationRecord
  def self.created_at_desc
    order(created_at: :desc)
  end
  
  def self.min_price(min_value)
    where('price >= ?', min_value)
  end

  def self.max_price(max_value)
    where('price <= ?', max_value)
  end

  def self.name_contains(term)
    where('name ILIKE ?', "%#{term}%")
  end
end