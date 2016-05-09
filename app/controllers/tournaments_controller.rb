class TournamentsController < ApplicationController

  def index
    @q = Tournament.search(params[:q])
    @tournaments = @q.result.order("name").where(active: true).page params[:page]
    @categories = @tournaments.group_by(&:category)
  end

  def show
    @user = current_user
    @tournament = Tournament.find(params[:id])
    @teams = @tournament.tournament_rankings
    @active_tournament_team = nil
    @tournament_team = TournamentTeam.new
    @matches = Match.current_week_matches(@tournament)
    @news = @tournament.news.order('created_at DESC').page params[:page]
    @current_user_teams = []
    gon.challonge_url = ""
    if @tournament.tournament_type == "Bracket"
      gon.challonge_url = @tournament.challonge_url
    end
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
    @teams = @tournament.tournament_rankings
  end
end
