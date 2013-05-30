class Commute < ActiveRecord::Base
  attr_accessible :date, :driver_id

  belongs_to :driver, class_name: User
  has_many :participations

  def to_param
    date
  end

  def user_went?(user)
    participations.exists?(['user_id = ?', user.id])
  end
end
