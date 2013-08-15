class Api::TeamsController < ApplicationController
	PAGESIZE = 5
	
	def index
		page = params[:page].to_i
		#extremely inefficient pagination
		teams = Team.order(:name)[ (page - 1) * PAGESIZE, PAGESIZE ]
		response = {}
		response[:teams] = []
		teams.each do |team| 
			response[:teams] << { 
				:id => team.id, :name => team.name, :owners => team.owners, :tag => team.tag, :tournaments => team.tournaments.map { |t| t.id }, 
				:memberships => team.memberships.map { |membership| { :user => User.find(membership.user_id), :team_id => membership.team_id, :id => membership.id, :active => membership.active, :role => membership.role } }
			}
		end
		response[:total_pages] = ( ( Team.count - 1) / PAGESIZE ).floor + 1
		render :json => response
		return
 	end
end
