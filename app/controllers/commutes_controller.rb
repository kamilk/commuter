class CommutesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @commutes = Commute.all  
    @users = User.all
    @day_summaries = DaySummary.for_date_range(Date.civil(2012,1,1), Date.civil(2014,1,1))
  end

  def new
  end

  def create
    data = ActiveSupport::JSON.decode(params['data'])
    Commute.transaction do
      data.each do |commute_data|
        commute = Commute.new
        commute.driver = User.find(commute_data['driver'])
        commute.date = Date.civil(2013, 05, 24)
        commute_data['participations'].each do |participation_data|
          participation = commute.participations.build
          participation.user = User.find(participation_data['user_id'])
        end
        commute.save
      end
    end
    redirect_to root_path
  end
end
