class Admin::TournamentsController < AdminController

  def new

  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])

    if @tournament.update_attributes(params[:tournament])
      redirect_to admin_root_path
      flash[:notice] = "Tournament Successfully Updated"
    else
      redirect_to admin_edit_tournament_path(@tournament)
      flash[:error] = "Failed to Update Tournament"
    end
  end

end
