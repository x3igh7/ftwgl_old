class Admin::MatchesController < AdminController
	def index
		tournament_id = params[:tournament_id].to_i
		tournament = Tournament.find(tournament_id)
		matches = Match.where(:tournament_id => tournament_id) #is this safe against SQL injection?
		response = []
		matches.each do |match|
			response.push( { 
				:home_team => TournamentTeam.find(match.home_team_id).team.tag, 
				:away_team => TournamentTeam.find(match.away_team_id).team.tag,
				:home_score => match.home_score,
				:away_score => match.away_score,
				:match_date => match.match_date
			})
		end
		render :json => response
	end
end
