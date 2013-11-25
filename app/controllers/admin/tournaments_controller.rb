class Admin::TournamentsController < AdminController

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(params[:tournament])

    if @tournament.save
      redirect_to tournament_path(@tournament)
      flash[:notice] = "Successfully created tournament"
    else
      flash[:alert] = "Failed to create tournament"
      render :new
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])

    if @tournament.update_attributes(params[:tournament])
      redirect_to admin_root_path
      flash[:notice] = "Tournament Successfully Updated"
    else
      redirect_to admin_edit_tournament_path(@tournament)
      flash[:error] = "Failed to Update Tournament"
    end
  end

  def rankings
    @tournament = Tournament.find(params[:tournament_id])
    @teams = TournamentTeam.in_tournament(@tournament).ranking
    @ranks = []

    for i in 1..@teams.length
      @ranks << i
    end
  end

  def update_rankings
    @tournament = Tournament.find(params[:tournament_id])

    if TournamentTeam.update(params[:teams].keys, params[:teams].values)
      redirect_to :back
      flash[:notice] = "ranks successfully updated"
    else
      render "rankings"
      flash[:alert] = "unable to update ranks"
    end
  end

  def schedule
    @tournament = Tournament.find(params[:tournament_id])
    @teams = TournamentTeam.in_tournament(@tournament).order(:rank)
  end

end
