class CommutesController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    data = ActiveSupport::JSON.decode(params['data'])
    logger.debug data
    Commute.transaction do
      data.each do |commute_data|
        commute = Commute.new
        commute.driver = User.find(commute_data['driver'])
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
