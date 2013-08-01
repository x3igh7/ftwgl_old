class Admin::MatchesController < AdminController
	def index
		tournament_id = params[:tournament_id].to_i
		tournament = Tournament.find(tournament_id)
		matches = Match.where(:tournament_id => tournament_id) #is this safe against SQL injection?
		response = {}
		matches.each do |match|
			week = match.week_num
			if response[week].nil?
				response[week] = []
			end
			response[week].push({ 
				:id => match.id,
				:tournament_id => match.tournament_id,
				:home_team_id => match.home_team_id,
				:away_team_id => match.away_team_id,
				:home_score => match.home_score,
				:away_score => match.away_score,
				:match_date => match.match_date
			})
		end
		#return hash grouped by week number
		render :json => response
	end
	
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
