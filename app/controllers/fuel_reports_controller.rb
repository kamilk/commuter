class FuelReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_must_own_report, only: [:edit, :update]

  def index
    @reports = FuelReport.all
  end

  def new
    @report = current_user.fuel_reports.build
  end

  def create
    @report = current_user.fuel_reports.build(params[:fuel_report])
    try_save(@report)
  end

  def edit
  end

  def update
    @report.update_attributes(params[:fuel_report])
    try_save(@report)
  end
  
  private

  def user_must_own_report
    @report = current_user.fuel_reports.find_by_id(params[:id])
    if @report.nil?
      flash[:alert] = 'The fuel report does not exist or you are not allowed to edit it.'
      redirect_to fuel_reports_path
    end
  end
  
  def try_save(report)
    if report.save
      flash[:notice] = "Fuel report saved"
      redirect_to fuel_reports_path
    else
      unless report.errors[:base].blank?
        flash[:alert] = report.errors[:base].join
      end
      render 'new'
    end
  end
end
