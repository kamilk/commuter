class Commute < ActiveRecord::Base
  attr_accessible :date, :driver_id

  belongs_to :driver, class_name: User
  has_many :participations, dependent: :delete_all
  has_many :users, through: :participations

  validates :driver_id, uniqueness: { scope: :date }

  def self.find_by_date_and_driver_id(date, driver_id)
    where(['date = ? AND driver_id = ?', date, driver_id]).first
  end

  def self.by_driver_and_participant(user1, user2)
    user1.commutes.where(['driver_id = ?', user2.id])
      .concat(user2.commutes.where(['driver_id = ?', user1.id]))
  end

  def to_param
    date
  end

  def user_went?(user, direction = nil)
    participation = participations.find_by_user_id(user.id)
    if participation.nil?
      return false
    elsif direction.nil?
      return true
    elsif direction == :to
      return participation.went_to
    else
      return participation.went_from
    end
  end

  def to_json
    result = {
      id: id,
      driver: driver_id,
      participations: []
    }
    participations.each do |participation|
      result[:participations] << {
        id: participation.id,
        user: participation.user_id,
        went_to: participation.went_to,
        went_from: participation.went_from
      }
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
      participation = participations.find_by_user_id(user_id)
      if participation.nil?
        participation = participations.build user_id: user_id
      end
      participation.went_to = participation_entry['went_to']
      participation.went_from = participation_entry['went_from']
    end
  end

  def number_of_people
    participations.count
  end
end
