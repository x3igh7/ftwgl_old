class Admin::MatchesController < AdminController
	def create
		@match = Tournament.find(params[:tournament_id]).matches.new(params[:match])
		if @match.save
			render :json => { :success => true }
		else
			render :json => { :success => false }
		end
	end
	
	def update
		@match = Match.find(params[:id])
    @home_team = @match.home_team.team
    @away_team = @match.away_team.team

    if @match.home_score > @match.away_score
      @match.winner_id = @home_team.id
    else
      @match.winner_id = @away_team.id
    end

    if @match.update_attributes(params[:match]) && @match.update_tourny_teams_scores
      render :json => { :success => true }
    else
      render :json => { :success => false }
    end
	end
	
	def destroy
		@match = Match.find(params[:id])
		if Match.destroy(params[:id])
			render :json => { :success => true, :match => @match }
		else
			render :json => { :success => true, :match => @match }
		end
	end
end
