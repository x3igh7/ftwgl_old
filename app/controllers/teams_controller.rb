class TeamsController < ApplicationController
  def index
    @q_teams = Team.search(params[:q])
    @teams = @q_teams.result.order("name").page params[:page]
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])

    if @team.save_with_owner(current_user)
      redirect_to team_path(@team)
      flash[:notice] = 'Successfully created team'
    else
      flash[:alert] = 'Failed to create team'
      render :new
    end
  end

  def show
    @team = Team.find(params[:id])
    @current_tournaments = @team.tournaments.where(active: true)
    @user = current_user

    @new_membership = Membership.new

    @membership = @team.memberships
    @team_info = @team.team_info
  end

  def edit
    @team = Team.find(params[:id])
    @membership = @team.memberships

    if current_user.has_team_permissions?(@team)
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
      flash[:notice] = 'Team Updated Successfully!'
    else
      render 'edit'
      flash[:alert] = 'Update Unsuccessful.'
    end
  end


end
