class HomeController < ApplicationController

  def home
    if user_signed_in?
      @teams = current_user.teams
      @tournaments = Tournament.all
    end
  end
end
