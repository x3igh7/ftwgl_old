class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
    @prev_matches = @user.get_previous_matches
    @comments = @user.comments.limit(5)
    @upcoming_matches = @user.get_upcoming_matches
  end

  def index
    @q = User.where('confirmed_at IS NOT NULL').search(params[:q])
    @users = @q.result.includes(:teams).order('username').page params[:page]
  end
end
