class FuelReport < ActiveRecord::Base
  attr_accessible :from_date, :to_date, :price_per_km
  
  belongs_to :user

  validates :from_date, :to_date, :price_per_km, presence: true
  validates :price_per_km, greater_than: 0
  validates_with DateRangeValidator
  validates_with FuelReportValidator
end
