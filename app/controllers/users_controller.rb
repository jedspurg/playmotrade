class UsersController < ApplicationController

  def index
  	@users = User.all #scope this to active users eventually
  end

  def new
  	@user = User.new
  end

end