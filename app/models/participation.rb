class Participation < ActiveRecord::Base
  attr_accessible :commute_id, :user_id, :went_to, :went_from

  belongs_to :user
  belongs_to :commute

  validates :user_id, uniqueness: { scope: :commute_id }
end
