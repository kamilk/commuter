class Participation < ActiveRecord::Base
  attr_accessible :commute_id, :user_id

  belongs_to :user
  belongs_to :commute

  validates :user_id, uniqueness: { scope: :commute_id }
end
