class MatchesController < ApplicationController

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.new
    @teams = allTournyTeams(@tournament)
  end

  def create
  end

end
