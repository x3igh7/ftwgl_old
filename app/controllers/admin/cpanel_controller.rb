class Admin::CpanelController < AdminController

  def index
    @active_tournaments = Tournament.where("active = true")
    @users = User.order("username").page params[:page]
    @teams = Team.order("name").page params[:page]
  end

end
