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
    @team = params[:team_id]
    @status = params[:active]
    @membership = Membership.where("team_id = ?", params[:team_id]).where("user_id = ?", params[:user_id])
    if @membership[0].update_attributes(:active => @status)
      redirect_to team_path(@team)
      flash[:notice] = 'Member status changed'
    else
      render 'teams/show'
      flash[:alert] = "Unable to change member status"
    end
  end

end
