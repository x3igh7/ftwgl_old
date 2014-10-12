class HomeController < ApplicationController

  def home
    if user_signed_in?
      @user = current_user
      @news = News.where(newsable_id: 0).order('created_at DESC').page params[:page]
      @teams = @user.teams
      @tournaments = []
      @user.tournaments.each do |tournament|
        if tournament.active == true
					@tournaments << tournament
        end
      end
    else
      @news = News.where(newsable_id: 0).order('created_at DESC').page params[:page]
    end
  end
end
