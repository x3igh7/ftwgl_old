class Admin::TournamentsController < AdminController
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
