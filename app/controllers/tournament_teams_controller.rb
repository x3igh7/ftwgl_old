class TournamentTeamsController < ApplicationController
  def create
    @tournament = Tournament.find(params[:tournament_team][:tournament])
    @tournament_team = TournamentTeam.new()
    @tournament_team.team_id = params[:tournament_team][:team]
    @tournament_team.tournament_id = @tournament.id
    
    if @tournament_team.save
      flash[:notice] = "Added team to Tournament"
      redirect_to tournament_path(@tournament)
    else
      flash[:alert] = "Failed to add team to Tournament"
      redirect_to tournament_path(@tournament)
    end

  end
end
