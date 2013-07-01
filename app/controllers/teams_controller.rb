class TeamsController < ApplicationController
load_and_authorize_resource

  def index 
    @team = Team.order("name")
  end

  def new
    @team = Team.new    
  end

  def create
    @team = Team.new(params[:team])
    
    if @team.save_with_owner(current_user)
      redirect_to team_path(@team)
      flash[:notice] = "Successfully created team"
    else
      flash[:alert] = "Failed to create team"
      render :new
    end
  end

  def show
    @team = Team.find(params[:id])
    @user = current_user
    @membership = @team.memberships
    @total_wins = 0
    @total_losses = 0

    @team.tournament_teams.each do |ranking|
      @total_wins += ranking.wins
      @total_losses += ranking.losses
    end
    
    if @total_wins == 0
      @winning_perc = 0.0
    else
      @winning_perc = @total_wins.to_f / (@total_losses + @total_wins)
    end
    @winning_perc.round(2)
  end

  def edit
    @team = Team.find(params[:id])
    if @team.owners.include?(current_user)
      true
    else
      redirect_to team_path(@team)
      flash[:alert] = "You are not the owner of this team"
    end
  end

  def update
    @team = Team.find(params[:id])

    if @team.update_attributes(params[:team])
      redirect_to @team
      flash[:notice] = "Team Updated Successfully!"
    else
      render 'edit'
      flash[:alert] = "Update Unsuccessful."
    end
  end


end
