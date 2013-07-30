class Admin::TournamentsController < AdminController
	def index
		@tournaments = Tournament.find(:all)
		render :json => @tournaments
	end
end
