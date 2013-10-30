class Admin::MatchesController < AdminController

  def index
    @tournament = Tournament.find(params[:tournament_id])
    @matches = Match.in_tournament(@tournament).order("week_num")
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @match = @tournament.matches.new

    @teams = @tournament.tournament_teams.map do |tourny_team|
      [tourny_team.team.name, tourny_team.id]
    end
  end

  def create
    @tournament = Tournament.find(params[:match][:tournament_id])
    @match = @tournament.matches.new(params[:match])

    if @match.save
      flash[:notice] = "Match created"
      redirect_to admin_matches_path(:tournament_id => @tournament.id)
    else
      flash[:alert] = "Failed to create match"
      redirect_to new_admin_match_path(:tournament_id => @tournament.id)
    end
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
    @match.match_date = params[:match][:match_date]

    if @match.save
      redirect_to admin_matches_path(:tournament_id => @match.tournament_id)
      flash[:notice] = "Tournament Successfully Updated"
    else
      redirect_to edit_admin_match_path(@match)
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
