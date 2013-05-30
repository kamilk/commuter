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
    redirect_to edit_commute_path(Date.today)
  end

  def edit
    @date = Date.parse(params[:id])
  end

  def update
    data = ActiveSupport::JSON.decode(params['data'])
    Commute.transaction do
      date = Date.parse(data['date'])
      data['commutes'].each do |commute_data|
        driver_id = commute_data['driver']
        commute = Commute.find_by_date_and_driver_id(date, driver_id)
        if commute.nil?
          commute = Commute.new
          commute.driver = User.find_by_id(driver_id)
          commute.date = date
        end

        commute.set_participations(commute_data['participations'])

        commute.save
      end
    end
    redirect_to root_path
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
