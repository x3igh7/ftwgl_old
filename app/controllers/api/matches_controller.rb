class Api::MatchesController < ApplicationController
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
end
