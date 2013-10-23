class Admin::TournamentTeamsController < AdminController

  def index
    @teams = TournamentTeam.where("tournament_id = ?", params[:tournament_id])
  end

end
