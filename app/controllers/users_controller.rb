class UsersController < ApplicationController

  def index
    @users = User.active
  end

  def show
    @user = User.find_by(:id => params[:id])
    if @user.blank?
      flash[:notice] = "No user with that ID could be found."
    end
  end

end