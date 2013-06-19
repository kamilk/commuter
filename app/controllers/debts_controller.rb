class DebtsController < ApplicationController
  def index
    @debts = Debt.all_by_user
    @users = @debts.keys
  end
end
