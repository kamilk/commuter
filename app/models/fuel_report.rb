class FuelReport < ActiveRecord::Base
  attr_accessible :from_date, :to_date, :price_per_km
  
  belongs_to :user

  validates :from_date, :to_date, :price_per_km, presence: true
  validates :price_per_km, greater_than: 0
  validates_with DateRangeValidator
  validates_with FuelReportValidator
  
  def self.for_commute(commute)
    commute.driver.fuel_reports.where(['from_date <= ? AND to_date >= ?', commute.date, commute.date]).first
  end

  def applies_to?(commute)
    commute.driver == user && commute.date >= from_date && commute.date <= to_date
  end
end
