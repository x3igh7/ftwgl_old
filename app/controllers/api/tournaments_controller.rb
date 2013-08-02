class Api::TournamentsController < ApplicationController
	def index
		@tournaments = Tournament.find(:all)
		@tournamentsWithTeams = []
		#append tournaments with tournament teams included
		@tournaments.each do |tournament|
			@tournamentsWithTeams.push({
				:description => tournament.description,
				:id => tournament.id,
				:name => tournament.name,
				:rules => tournament.rules,
				:teams => Hash[(tournament.tournament_teams.map{|team| {:id => team.id, :tag => team.team.tag }}).map{|team| [ team[:id], team ] }]
			})
		end
		#return hash grouped by tournament id
		render :json => Hash[@tournamentsWithTeams.map{|tournament| [tournament[:id], tournament]}]
	end
end
