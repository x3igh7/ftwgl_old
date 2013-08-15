class Admin::TeamsController < AdminController
	def update
		@team = Team.find(params[:id])
		
		if @team.update_attributes(params[:team])
			render :json => { :success => true, :team => @team }
		else
			render :json => { :success => false, :team => @team }
		end
	end
end
