class Admin::TournamentTeamsController < AdminController

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @teams = TournamentTeam.in_tournament(@tournament)
  end

end
