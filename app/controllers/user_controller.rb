class UserController < ApplicationController

  def show
    @user = User.find(params[:id])
    @prev_matches = @user.matches.where('winner_id IS NOT NULL').limit(5).order(:created_at)
  	@wins = @user.total_wins
  	@losses = @user.total_losses
  	@winning_perc = @user.winning_perc
  	@comments = @user.comments.limit(5)
  end

  def index
  	@q = User.search(params[:q])
    @users = @q.result.includes(:teams).order("username").page params[:page]
  end
end
