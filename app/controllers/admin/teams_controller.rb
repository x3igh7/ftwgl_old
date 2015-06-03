class Admin::TeamsController < AdminController
  before_filter :enforce_permissions

  def edit
    @team = Team.find(params[:id])
    enforce_tournament_admin_teams(@team)
    @membership = @team.memberships
  end

  def update
    @team = Team.find(params[:id])
    enforce_tournament_admin_teams(@team)

    if @team.update_attributes(params[:team])
      redirect_to edit_admin_team_path(@team)
      flash[:notice] = "Team Updated Successfully!"
    else
      render 'edit'
      flash[:alert] = "Update Unsuccessful."
    end
  end

  def destroy
    enforce_permissions
    @team = Team.find(params[:id])
    enforce_tournament_admin_teams(@team)

    if @team.delete
      flash[:notice] = "Team deleted."
      redirect_to admin_root_path
    else
      flash[:alert] = "Unable to delete Team."
      redirect_to admin_root_path
    end
  end

  private

  def enforce_permissions
    if not current_user.has_role?(:admin)
      flash[:alert] = "You don't have sufficient permissions to do that."
      redirect_to admin_root_path
    end
  end

  def enforce_tournament_admin_teams(team)
    if current_user.is_tournament_admin? && !current_user.has_role?(:admin)
      teams = current_user.admin_teams
      if !teams.include?(team)
        flash[:alert] = "You don't have sufficient permissions to do that."
        redirect_to admin_root_path
      end
    end
  end

end
