class HomeController < ApplicationController

  def home
    if user_signed_in?
      @teams = current_user.teams
			@tournaments = current_user.tournaments
    end
  end
end
