class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    data = User.all.map{ |user| {id: user.id, name: user.name} }
    respond_to do |format|
      format.json { render json: data }
    end
  end
end
