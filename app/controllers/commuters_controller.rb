class CommutersController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: get_users_data }
    end
  end

  private

  def get_users_data
    User.all.map{|u| {id: u.id, name: u.name}}
  end
end
