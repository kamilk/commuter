class FuelReport < ActiveRecord::Base
  attr_accessible :from, :price_per_km, :to, :user_id
  
  belongs_to :user
end
