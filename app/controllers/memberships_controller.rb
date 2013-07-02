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
      flash[:alert] = "Error submitting application."
      render "teams/show"
    end
  end

  def update
    @team = Team.find(params[:team_id])
    @status = params[:active]
    @membership = users_current_team(params)
    if @membership[0].update_attributes(:active => @status)
      redirect_to team_path(@team)
      flash[:notice] = 'Member status changed'
    else
      render 'teams/show'
      flash[:alert] = "Unable to change member status"
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    @membership = users_current_team(params)
    @membership[0].destroy

    redirect_to team_path(@team)
  end

end
