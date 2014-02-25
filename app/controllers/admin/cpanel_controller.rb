class Admin::CpanelController < AdminController

  def index
    @active_tournaments = Tournament.where("active = true")
    @users = User.order("username").page params[:page_1]
    @teams = Team.order("name").page params[:page_2]
    @news = News.order("created_at").page params[:page_3]
  end

end
