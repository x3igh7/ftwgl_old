class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_sidebar, :enforce_ban

  def load_sidebar
    if user_signed_in?
      @user = current_user
      @team_tournaments = []
      @team_tournament_matches = []
      @user.teams.each do |team|
        team.tournament_teams.each do |tournament_team|
          @team_tournaments << tournament_team.tournament
          tournament_team.matches.each do |match|
            if match.winner_id == nil
              @team_tournament_matches << match
            end
          end
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
