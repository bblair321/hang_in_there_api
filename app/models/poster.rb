class Poster < ApplicationRecord
  def self.created_at_desc
    order(created_at: :desc)
  end
end