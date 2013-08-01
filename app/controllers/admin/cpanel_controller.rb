class Admin::CpanelController < AdminController
	def index
		teams = Team.find(:all)
		@teams = {}
		teams.each do |team|
			@teams[team.id] = team
		end
	end
end
