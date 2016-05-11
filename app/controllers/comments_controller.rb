class CommentsController < ApplicationController
  def create
    unless params[:news_id].nil?
      @user = current_user
      @news = News.find(params[:news_id])
      @comment = @news.comments.build(:content => params[:comment][:content], :user_id => @user.id )
      if @comment.save
        flash[:notice] = 'Comment accepted'
        redirect_to :back
      else
        flash[:alert] = @comment.errors.full_messages.first
        redirect_to news_path(@news)
      end
    end

    unless params[:match_id].nil?
      @match = Match.find(params[:match_id])
      @home_team = @match.home_team.team
      @away_team = @match.away_team.team
      @comment = @match.comments.build( :content => params[:comment][:content], :user_id => current_user.id )
      if @comment.save
        flash[:notice] = 'Comment accepted'
        redirect_to :back
      else
        flash[:alert] = @comment.errors.full_messages.first
        redirect_to tournament_match_path(@match)
      end
    end
  end
end
