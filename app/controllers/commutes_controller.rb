class CommutesController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    logger.debug params[:data]
    redirect_to root_path
  end
end
