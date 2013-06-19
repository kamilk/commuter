class FuelReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @reports = FuelReport.all
  end

  def new
    @report = current_user.fuel_reports.build
  end

  def create
    @report = current_user.fuel_reports.build(params[:fuel_report])
    if @report.save
      flash[:notice] = "Fuel report saved"
      redirect_to fuel_reports_path
    else
      unless @report.errors[:base].blank?
        flash[:alert] = @report.errors[:base].join
      end
      render 'new'
    end
  end
end
