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
	
	def schedule
		tournament_id = params[:tournament_id]
		tournament = Tournament.find(tournament_id)
		tournament_teams = Tournament.find(params[:tournament_id]).tournament_teams
		if tournament.current_week_num.nil?
			current_week_num = 1
		else
			current_week_num = tournament.current_week_num + 1;
		end
		paired = {}
		matches = []
		tournament_teams.ranking.each do |home_team|
			if not paired[home_team.id]
				paired[home_team.id] = true
				tournament_teams.ranking.each do |away_team|
					if not paired[away_team.id] and not away_team.has_played?(home_team)
						paired[away_team.id] = true
						match = tournament.matches.build({
								:home_team_id => home_team.id, 
								:away_team_id => away_team.id,
								:week_num => current_week_num
							}.merge(params[:match])
						)
						if not match.save
							render :json => { :success => false }
							return
						end
						matches << match
						break
					end
				end
			end
		end	
		if not matches.any?
			render :json => { :success => false }
			return
		end
		tournament.update_attributes :current_week_num => current_week_num
		render :json => { :success=> true, :tournament => tournament }
	end
end
