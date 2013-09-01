class UsersController < ApplicationController

  def index
    @users = User.active
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(:id => params[:id])
    if @user.blank?
      flash[:notice] = "No user with that ID could be found."
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Account created"
      redirect_to users_path
    else
      render :action => :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "Account updated"
    end
    render :action => :edit
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Account deleted"
    end
    redirect_to users_path
  end

  private #####################################################################

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :telephone,
                                 :address1, :address2, :country, :state, :city,
                                 :zip, :about, :username, :password, :password_confirmation,
                                 :agrees_to_tos)
  end

end