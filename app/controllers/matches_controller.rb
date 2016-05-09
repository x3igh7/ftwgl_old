class MatchesController < ApplicationController

  def show
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])
    @home_team = @match.home_team.team
    @away_team = @match.away_team.team
    @comments = @match.comments
  end

  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])
    @home_team = @match.home_team.team
    @away_team = @match.away_team.team

    if user_signed_in?
      if current_user.is_team_owner?(@home_team) || current_user.is_team_owner?(@away_team)
        true
      else
        flash[:alert] = "You are not authorized to view this page."
        redirect_to tournament_match_path(@tournament.id, @match.id)
      end
    else
      flash[:alert] = "You are not authorized to view this page."
      redirect_to tournament_match_path(@tournament.id, @match.id)
    end
  end

  def update
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.find(params[:id])
    @home_team = @match.home_team.team
    @away_team = @match.away_team.team

    if @match.update_attributes(params[:match]) && @match.update_tourny_teams_scores
      if @match.home_score > @match.away_score
        @match.winner_id = @home_team.id
        @match.save
      elsif @match.home_score < @match.away_score
        @match.winner_id = @away_team.id
        @match.save
      end
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

  def upload_screenshot
    @match = Match.find(params[:id])

    if(@match.update_attributes(params[:match]))
      flash[:notice] = 'Match screenshots updated.'
      redirect_to tournament_match_path(@tournament.id, @match.id)
    else
      flash[:alert] = 'Failed upload match screenshots.'
      render 'matches/edit'
    end
  end
end
