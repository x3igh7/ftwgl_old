class Admin::CpanelController < AdminController

  def index
    @active_tournaments = Tournament.where("active = true")
  end

end
