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
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account created"
      redirect_to users_path
    else
      render :action => :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
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

end