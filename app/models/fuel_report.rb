class FuelReport < ActiveRecord::Base
  attr_accessible :from, :price_per_km, :to, :user_id
  
  belongs_to :user

  validates :from, :to, :price_per_km, presence: true
  validates :price_per_km, greater_than: 0
  validates_with DateRangeValidator
  validates_with FuelReportValidator
end
