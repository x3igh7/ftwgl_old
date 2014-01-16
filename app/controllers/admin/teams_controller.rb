class Admin::TeamsController < AdminController

  def destroy
    @team = Team.find(params[:id])

    if @team.delete
      flash[:notice] = "Team deleted."
      redirect_to admin_root_path
    else
      flash[:alert] = "Unable to delete Team."
      redirect_to admin_root_path
    end
  end

end
