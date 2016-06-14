class MatchDemosController < ApplicationController
  def new
    @demo = MatchDemo.new
    @match = Match.find(params[:match_id])
  end

  def create
    @demo = MatchDemo.new(params[:match_demo])

    @demo.user = current_user
    @demo.match = Match.find(params[:match_id])

    @demo.save
  end
end
