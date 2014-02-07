class HomeController < ApplicationController

  def home
    @news = News.where(newsable_id: 0).page params[:page]
    if user_signed_in?
      @user = current_user
      @teams = @user.teams
			@tournaments = @user.tournaments
    end
  end
end
