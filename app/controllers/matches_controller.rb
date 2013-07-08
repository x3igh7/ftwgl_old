class MatchesController < ApplicationController

  def show
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @match = @tournament.matches.new

    @teams = @tournament.tournament_teams.map do |tourny_team| 
      [tourny_team.team.name, tourny_team.id]
    end
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @match = @tournament.matches.new(params[:match])
    # @date = "#{params[:match]["match_date(1i)"]}/#{params[:match]["match_date(2i)"]}/#{params[:match]["match_date(3i)"]}"
    # @match.match_date = @date
    # @match.home_team_id = params[:match][:home_team]
    # @match.away_team_id = params[:match][:away_team]
    # @match.week_num = params[:match][:week_num]
    if params[:match][:home_team_id] != params[:match][:away_team_id] && @match.save
      flash[:notice] = "Match created"
      redirect_to tournament_match_path(:tournament_id => @tournament.id, :id => @match.id)
    else
      flash[:alert] = "Failed to create match"
      render 'matches/new'
    end
  end

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @matches = @tournament.matches
  end

end
