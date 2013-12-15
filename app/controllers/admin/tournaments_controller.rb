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
    @match = Match.new
    @tournament = Tournament.find(params[:tournament_id])
    @teams = TournamentTeam.in_tournament(@tournament).order(:rank)
    @team_names = @teams.map do |tourny_team|
      [tourny_team.team.name, tourny_team.id]
    end

    @matchups = @tournament.scheduler
  end

  def create_schedule
    @tournament = Tournament.find(params[:tournament_id])
    @matches = params[:matches]
    match_date = date_converter(params)
    if schedule_creater(@matches, params, match_date)
      flash[:notice] = "matches successfully created!"
      redirect_to admin_root_path
    else
      flash[:alert] = "failed to save schedule"
      redirect_to :back
    end

  end

  private

  def date_converter(params)
    match_date = DateTime.civil(
      params[:match_date]["date(1i)"].to_i,
      params[:match_date]["date(2i)"].to_i,
      params[:match_date]["date(3i)"].to_i,
      params[:match_date]["date(4i)"].to_i,
      params[:match_date]["date(5i)"].to_i)
  end

  def schedule_creater(matches, params, match_date)
    Match.transaction do
      matches.each do |match|
        Match.create(home_team_id: match["home_team_id"].to_i,
          away_team_id: match["away_team_id"].to_i,
          tournament_id: params[:tournament_id].to_i,
          week_num: params[:week].to_i,
          match_date: match_date)
      end
    end
  end

end
