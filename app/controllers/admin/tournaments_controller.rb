class Admin::TournamentsController < AdminController
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
	
	def create
		@tournament = Tournament.new(params[:tournament])
		if @tournament.save
			render :json => { :success => true, :tournament => @tournament }
		else
			render :json => { :success => false, :tournament => @tournament }
		end
	end
	
	def destroy
		@tournament = Tournament.find(params[:id])
		if Tournament.destroy(params[:id])
			render :json => { :success => true, :tournament => @tournament }
		else
			render :json => { :success => false, :tournament => @tournament }
		end
	end
	
	def update
		@tournament = Tournament.find(params[:id])
		if @tournament.update_attributes(params[:tournament])
			render :json => { :success => true, :tournament => @tournament }
		else
			render :json => { :success => false, :tournament => @tournament }
		end
	end
end
