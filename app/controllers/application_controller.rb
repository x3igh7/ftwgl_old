class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_sidebar, :enforce_ban

  def load_sidebar
    if user_signed_in?
      @team_tournaments = current_user.tournaments
      @team_tournament_matches = []
      @team_tournaments.each do |tourny|
        if tourny.matches.count != 0
          @team_tournament_matches = tourny.tournament_teams.last.matches
        end
      end
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
	def enforce_ban
		if user_signed_in? and current_user.banned?
			sign_out current_user
			redirect_to root_path, :notice => "Your account has been suspended."
		end
	end
end
