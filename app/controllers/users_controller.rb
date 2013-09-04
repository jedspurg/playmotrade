class UsersController < ApplicationController

  def index
    @users = User.active.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @user = User.find_by(:id => params[:id])
    if @user.blank?
      flash[:notice] = "No user with that ID could be found."
    end
  end

end