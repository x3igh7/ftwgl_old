class Admin::TournamentsController < AdminController
	def index
		@tournaments = Tournament.find(:all)
		@tournamentsWithTeams = []
		@tournaments.each do |tournament|
			@tournamentsWithTeams.push({
				:description => tournament.description,
				:id => tournament.id,
				:name => tournament.name,
				:rules => tournament.rules,
				:teams => tournament.tournament_teams.map{|team| {:id => team.id, :tag => team.team.tag }}
			})
		end
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
