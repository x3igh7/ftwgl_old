class TournamentsController < ApplicationController

  def index 
    @tournament = Tournament.order("name")
  end

  def new
    @tournament = Tournament.new

    unless current_user.has_role? :admin
      redirect_to root_path
      flash[:alert] = "You are not authorized to access this page."
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
