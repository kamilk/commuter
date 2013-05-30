class Commute < ActiveRecord::Base
  attr_accessible :date, :driver_id

  belongs_to :driver, class_name: User
  has_many :participations

  validates :driver_id, uniqueness: { scope: :date }

  def self.find_by_date_and_driver_id(date, driver_id)
    where(['date = ? AND driver_id = ?', date, driver_id]).first
  end

  def to_param
    date
  end

  def user_went?(user)
    participations.exists?(['user_id = ?', user.id])
  end

  def to_json
    result = {
      id: id,
      driver: driver_id,
      participations: []
    }
    participations.each do |participation|
      result[:participations] << { id: participation.id, user: participation.user_id }
    end
    result
  end

  def set_participations(participation_data)
    participations_to_destroy = []
    participations.each do |participation|
      unless participation_data.any? { |data| data['user_id'] == participation.user_id }
        participations_to_destroy << participation
      end
    end

    participations_to_destroy.each do |participation|
      participation.destroy
    end

    participation_data.each do |participation_entry|
      user_id = participation_entry['user_id']
      unless participations.exists?(['user_id = ?', user_id])
        participations.build user_id: user_id
      end
    end
  end
end
