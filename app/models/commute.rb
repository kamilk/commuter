class Commute < ActiveRecord::Base
  attr_accessible :date, :driver_id

  belongs_to :driver, class_name: User
  has_many :participations
end
