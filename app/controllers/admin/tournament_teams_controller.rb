class Admin::TournamentTeamsController < AdminController

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @teams = TournamentTeam.in_tournament(@tournament).page params[:page]
  end

  def new
    @tournament = Tournament.find(params[:tournament])
    @q = Team.search(params[:q])
    @teams = @q.result(distinct: true).page params[:page]
  end

  def create
    @tournament = Tournament.find(params[:tournament])
    @added_team = Team.find(params[:tournament_team])
    @team = TournamentTeam.new()
    @team.team_id = @added_team.id
    @team.tournament_id = @tournament.id

    if @team.save
      flash[:notice] = "Team added to tournament."
      redirect_to new_admin_tournament_team_path(tournament: @tournament)
    else
      flash[:alert] = "Failed to add team to tournament. Make sure the team has not already joined."
      redirect_to new_admin_tournament_team_path(tournament: @tournament)
    end

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
