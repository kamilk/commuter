class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :colour
  # attr_accessible :title, :body
  
  has_many :participations
  has_many :commutes, through: :participations
  has_many :fuel_reports
  
  def to_s
    name
  end
end
