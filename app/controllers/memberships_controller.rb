class MembershipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @membership = Membership.new()
    @join_password = params[:membership][:join_password]
    @team = Team.find(params[:team])
    @membership.user = current_user
    @membership.team = @team

    if Team.authenicate_join(@team, @join_password)
      if @membership.save
        flash[:notice] = 'Application submitted.'
      else
        flash[:alert] = 'Error submitting application.'
      end
    else
      flash[:alert] = 'Invaild join password.'
    end

    redirect_to team_path(@team)
  end

  def update
    @team = Team.find(params[:team_id])
    @status = params[:active]
    @membership = users_current_team(params)
    if @membership[0].update_attributes(:active => @status)
      redirect_to team_path(@team)
      flash[:notice] = 'Member status changed'
    else
      redirect_to team_path(@team)
      flash[:alert] = 'Unable to change member status'
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    @membership = users_current_team(params)
    destroyed = @membership[0].destroy
    flash[:notice] = 'Removed ' + destroyed.user.username + ' from the team'
    redirect_to team_path(@team)
  end
end
