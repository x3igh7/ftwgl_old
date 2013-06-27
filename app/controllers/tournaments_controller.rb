class TournamentsController < ApplicationController

  def index 
    @tournament = Tournament.order("name")
  end

  def new
    @tournament = Tournament.new
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
