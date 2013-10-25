class Admin::MatchesController < AdminController

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @matches = Match.in_tournament(@tournament)
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to admin_matches_path(:tournament_id => @match.tournament_id) }
      format.json { head :no_content }
    end
  end

end
