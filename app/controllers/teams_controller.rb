class TeamsController < ApplicationController
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
  end

end
