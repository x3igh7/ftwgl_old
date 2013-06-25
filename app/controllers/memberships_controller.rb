class MembershipsController < ApplicationController

  def create
    @team = Team.find(params[:team_id])
    @membership = Membership.new()
    @membership.user = current_user
    @membership.team = @team
    if @membership.save
      flash[:notice] = "Application submitted."
      redirect_to team_path(@team)
    else
      flash[:error] = "Error submitting application."
      render "teams/show"
    end
  end

end
