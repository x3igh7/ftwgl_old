class HomeController < ApplicationController

  def home
    @news = News.where(newsable_id: 0).order('created_at DESC').page params[:page]
    if user_signed_in?
      @user = current_user
      @teams = @user.teams
      @tournaments = []
      @user.tournaments.each do |tournament|
        if tournament.active == true
          @tournaments << tournament
        end
      end
    end
  end
end
