class Admin::MatchesController < AdminController

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @matches = Match.in_tournament(@tournament)
  end

  def edit
    @match = Match.find(params[:id])
  end

  def update
    @match = Match.find(params[:id])
    @match.home_score = params[:match][:home_score]
    @match.away_score = params[:match][:away_score]
    @match.week_num = params[:match][:week_num]
    @match.winner_id = params[:match][:winner_id]

    if @match.update_attributes(params[:match])
      redirect_to admin_matches_path(:tournament_id => @match.tournament_id)
      flash[:notice] = "Tournament Successfully Updated"
    else
      redirect_to admin_edit_match_path(@match)
      flash[:error] = "Failed to Update Tournament"
    end
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
