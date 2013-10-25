class Admin::TournamentTeamsController < AdminController

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @teams_unsorted = TournamentTeam.in_tournament(@tournament)
    @teams = @teams_unsorted.sort { |a,b| a.team.name <=> b.team.name }
  end

  def edit
    @team = TournamentTeam.find(params[:id])
  end

  def update
    @team = TournamentTeam.find(params[:id])

    @team.wins = params[:tournament_team][:wins]
    @team.losses = params[:tournament_team][:losses]
    @team.total_points = params[:tournament_team][:total_points]
    @team.total_diff = params[:tournament_team][:total_diff]

    if @team.save
      redirect_to admin_tournament_teams_path(:tournament_id => @team.tournament_id)
      flash[:notice] = "Tournament Team Successfully Updated"
    else
      redirect_to edit_admin_tournament_team_path(@team.id)
      flash[:error] = "Failed to Update Tournament Team"
    end
  end

  def destroy
    @team = TournamentTeam.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to admin_tournament_teams_path(:tournament_id => @team.tournament_id) }
      format.json { head :no_content }
    end
  end

end
