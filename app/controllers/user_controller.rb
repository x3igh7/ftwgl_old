class UserController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.order("username").page params[:page]
  end
end
