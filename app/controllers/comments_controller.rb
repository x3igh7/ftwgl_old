class CommentsController < ApplicationController
	def create
		if not params[:match_id].nil?
			@match = Match.find(params[:match_id])
			@home_team = @match.home_team.team
			@away_team = @match.away_team.team
			if current_user.is_team_member?(@home_team) or current_user.is_team_member?(@away_team)
				@comment = @match.comments.build( :content => params[:comment][:content], :user_id => current_user.id )
				if @comment.save
					flash[:notice] = "Comment accepted"
					redirect_to tournament_match_path(@match.tournament, @match)
					return
				end
			end
		end
		
		#TODO: cases for other comment types e.g. tournament, news comments
		flash[:alert] = @comment.errors.full_messages.first
		redirect_to tournament_match_path(@match.tournament, @match)
	end
end
