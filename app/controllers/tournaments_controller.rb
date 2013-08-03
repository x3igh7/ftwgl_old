class TournamentsController < ApplicationController

  def index 
    @tournament = Tournament.order("name")
  end

  def new
    @tournament = Tournament.new

    unless user_signed_in? && current_user.has_role?(:admin)
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
		@teams = @tournament.tournament_teams.ranking
    @active_tournament_team = nil
    @tournament_team = TournamentTeam.new
    @current_user_teams = []
    if user_signed_in?
      current_user.teams.each do |team|
        if current_user.is_team_owner?(team)
          @current_user_teams << team
        end
      end
      @current_user_teams.each do |x| 
				@active_tournament_team = x.tournament_teams.in_tournament(@tournament).first
        if not @active_tournament_team.nil?
					 break
				end
      end
    end
		
		
		@matches = {}
		Tournament.find(params[:id]).matches.each do |match|
			if @matches[match.week_num].nil?
				@matches[match.week_num] = []
			end
			@matches[match.week_num] << match
		end
  end

  def rankings
    @tournament = Tournament.find(params[:tournament_id])
    @teams = @tournament.tournament_teams.ranking
  end

end
