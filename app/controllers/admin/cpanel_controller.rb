class Admin::CpanelController < AdminController
	def index
		@teams = Team.find(:all)
		
		@match = Match.new
	end
end
