class Admin::MembershipsController < AdminController

  def create
    @team = Team.find(params[:team_id])
    @membership = Membership.new()
    @membership.user = current_user
    @membership.team = @team
    if @membership.save
      flash[:notice] = "Application submitted."
      redirect_to team_path(@team)
    else
      flash[:alert] = "Error submitting application."
      redirect_to team_path(@team)
    end
  end

  def destroy
    team = Team.find(params[:team_id])
    membership = users_current_team(params)
    destroyed = membership[0].destroy
		render :json => { :team => team, :user => destroyed.user }
  end

end
