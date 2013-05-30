class CommutesController < ApplicationController
  before_filter :authenticate_user!

  def show
    date = Date.parse(params[:id])
    @commutes = Commute.where(['date = ?', date])

    respond_to do |format|
      format.json { render json: convert_commutes_to_json(@commutes) }
    end
  end

  def index
    @commutes = Commute.all  
    @users = User.all
    @day_summaries = DaySummary.for_date_range(Date.civil(2012,1,1), Date.civil(2014,1,1))
  end

  def new
    @date = Date.today
  end

  def create
    data = ActiveSupport::JSON.decode(params['data'])
    Commute.transaction do
      date = Date.parse(data['date'])
      data['commutes'].each do |commute_data|
        commute = Commute.new
        commute.driver = User.find(commute_data['driver'])
        commute.date = date
        commute_data['participations'].each do |participation_data|
          participation = commute.participations.build
          participation.user = User.find(participation_data['user_id'])
        end
        commute.save
      end
    end
    redirect_to root_path
  end

  def edit
    @date = Date.parse(params[:id])
  end

  private

  def convert_commutes_to_json(commutes)
    commutes.map do |commute|
      result = {
        id: commute.id,
        driver: commute.driver_id,
        participations: []
      }
      commute.participations.each do |participation|
        result[:participations] << { id: participation.id, user: participation.user_id }
      end
      result
    end
  end
end
