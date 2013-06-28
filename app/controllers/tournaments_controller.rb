class TournamentsController < ApplicationController

  def index 
    @tournament = Tournament.order("name")
  end

  def new
    @tournament = Tournament.new

    if current_user.role != 'admin'
      redirect_to root_path
      flash[:alert] = "You don't have permission to access this."
    end
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    
    if @tournament.save
      redirect_to tournament_path(@tournament)
      flash[:notice] = "Successfully created tournament"
    else
      flash[:alert] = "Failed to create tournament"
      render :new
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

end
