class TournamentsController < ApplicationController

  def index
    @tournaments = Tournament.order("name").where(active: true)
  end

  def show
    @tournament = Tournament.find(params[:id])
		@teams = @tournament.tournament_teams.ranking
    @active_tournament_team = nil
    @tournament_team = TournamentTeam.new
    @matches = Match.current_week_matches(@tournament)
    @current_user_teams = []
    if user_signed_in?
      current_user.teams.each do |team|
        if current_user.is_team_owner?(team)
          @current_user_teams << team
        end
      end
      @current_user_teams.each do |x|
				@active_tournament_team = x.tournament_teams.in_tournament(@tournament).first
        if not @active_tournament_team.nil?
					 break
				end
      end
    end

  end

  def rankings
    @tournament = Tournament.find(params[:tournament_id])
    @teams = @tournament.tournament_teams.ranking
  end

end
