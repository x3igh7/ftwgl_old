class UserController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def index 
    @user = User.order("username")
  end

end
