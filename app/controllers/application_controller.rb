class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_sidebar, :enforce_ban

  def load_sidebar
    if user_signed_in?
      @team_tournaments = current_user.tournaments
      @team_tournament_matches = {}
			current_user.teams.each do |team|
				team.tournament_teams.each do |tournament_team|
					@team_tournament_matches[tournament_team.tournament_id] = tournament_team.matches
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
