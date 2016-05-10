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
      if current_user.has_team_permissions?(@home_team) || current_user.has_team_permissions?(@away_team)
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

    if @match.save_and_update_match_results(params, current_user)
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
