class MatchesController < ApplicationController

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.new
  end

  def create
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.new()
    @date = "#{params[:match]["match_date(1i)"]}/#{params[:match]["match_date(2i)"]}/#{params[:match]["match_date(3i)"]}"
    @match.match_date = @date
    @match.home_team_id = params[:match][:home_team]
    @match.away_team_id = params[:match][:away_team]
    @match.week_num = params[:match][:week_num]

    if @match.save
      flash[:notice] = "Match created"
      redirect_to tournament_path(@tournament)
    else
      flash[:alert] = "Failed to create match"
      render 'matches/new'
    end
  end

end
