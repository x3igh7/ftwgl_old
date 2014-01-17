class Admin::MembershipsController < AdminController

  def destroy
    @team = Team.find(params[:team_id])
    @membership = users_current_team(params)
    destroyed = @membership[0].destroy
    flash[:notice] = 'Removed ' + destroyed.user.username + ' from the team'
    redirect_to edit_admin_team_path(@team)
  end

end
