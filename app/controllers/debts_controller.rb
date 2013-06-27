class DebtsController < ApplicationController
  before_filter :authenticate_user!

  def index
    log = DebtLog.from_commutes(Commute.all)
    @debts = log.debts_between_everyone
    @users = @debts.keys
  end

  def show
    @owing = User.find_by_id(params[:owing])
    @owed  = User.find_by_id(params[:owed])

    if @owing.blank? || @owed.blank?
      flash[:alert] = "Error"
      redirect_to root_path
      return
    end

    @log = DebtLog.from_commutes(Commute.by_driver_and_participant(@owed, @owing))
    @summary = @log.debt_between(@owing, @owed)
  end
end
