class Admin::MembershipsController < AdminController

  def create
    team = Team.find(params[:membership][:team_id])
		user = User.find(params[:membership][:user_id])
		membership = Membership.new()
		membership.team = team
		membership.user = user
		membership.active = true
    if membership.save
      render :json => { :success => true, :user => user, :team => team }
    else
      render :json => { :success => false, :user => user, :team => team }
    end
  end

  def destroy
    team = Team.find(params[:team_id])
    membership = users_current_team(params)
    destroyed = membership[0].destroy
		render :json => { :team => team, :user => destroyed.user }
  end

end
