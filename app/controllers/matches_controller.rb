class MatchesController < ApplicationController

  def show
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])
    @home_team = @match.home_team.team
    @away_team = @match.away_team.team
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
      redirect_to tournament_match_path(@tournament.id, @match.id)
    else
      flash[:alert] = "Failed to create match"
      render 'matches/new'
    end
  end

  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])
    @home_team = @match.home_team.team
    @away_team = @match.away_team.team

    if current_user.is_team_owner?(@home_team) || current_user.is_team_owner?(@away_team)
      true
    else
      flash[:alert] = "You are not authorized to view this page."
      redirect_to tournament_match_path(@tournament.id, @match.id)
    end
  end

  def update
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])


    if @match.update_attributes(params[:match])
      flash[:notice] = "Match results updated."
      redirect_to tournament_match_path(@tournament.id, @match.id)
    else
      flash[:alert] = "Failed to update match results."
      render 'matches/edit'
    end
  end

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @matches = @tournament.matches
  end

end
