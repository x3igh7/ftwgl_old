class TournamentsController < ApplicationController

  def index 
    @tournament = Tournament.order("name")
  end

  def new
    @tournament = Tournament.new

    unless current_user.has_role? :admin
      redirect_to root_path
      flash[:alert] = "You are not authorized to access this page."
    end
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

  def show
    @tournament = Tournament.find(params[:id])
    @has_active_team = false
    @tournament_team = TournamentTeam.new
    @current_user_teams = []
    if user_signed_in?
      current_user.teams.each do |team|
        if current_user.is_team_owner?(team)
          @current_user_teams << team
        end
      end
      @current_user_teams.each do |x| 
        has_active = x.tournament_teams.current_tourny(@tournament)
        if has_active.length > 0 
          @has_active_team = true
        end
      end
    end
  end

  def rankings
    @tournament = Tournament.find(params[:tournament_id])
    @teams = @tournament.tournament_teams
  end

end
