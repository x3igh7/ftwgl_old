class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
    @prev_matches = @user.matches.where('winner_id IS NOT NULL').limit(5).order(:created_at)
    @comments = @user.comments.limit(5)
    @upcoming_match = @user.matches.where('winner_id IS NULL').limit(5).order(:created_at)
  end

  def index
    @q = User.where('confirmed_at IS NOT NULL').search(params[:q])
    @users = @q.result.includes(:teams).order('username').page params[:page]
  end
end
