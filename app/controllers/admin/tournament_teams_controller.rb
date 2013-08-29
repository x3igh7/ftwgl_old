class Admin::TournamentTeamsController < AdminController
  def create
    tournament = Tournament.find(params[:tournament_team][:tournament])
		  team = Team.find(params[:tournament_team][:team])
    tournament_team = TournamentTeam.new()
    tournament_team.team_id = team.id
		tournament_team.tournament_id = tournament.id
    if tournament_team.save
			render :json => { :success => true, :team => team, :tournament => tournament}
    else
			render :json => { :success => false, :team => team, :tournament => tournament }
    end

  end
end
