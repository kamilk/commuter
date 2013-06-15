class FuelReportsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @report = current_user.fuel_reports.build
  end
end
