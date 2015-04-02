class Admin::CpanelController < AdminController

  def index
    @user = current_user
    @active_tournaments = Tournament.where("active = true")

    if @user.is_tournament_admin?
    	@active_tournaments = @user.admin_tournaments
    end

    @q_users = User.search(params[:q])
	  @q_teams = Team.search(params[:q])
	  @q_news = News.search(params[:q])

	  if(params[:q] != nil)

		  if(params[:q][:username_cont] != nil)
		  	@users = @q_users.result.order("username").page params[:page_1]
			else
				@users = User.order("username").page params[:page_1]
			end

			if(params[:q][:name_or_tag_cont] != nil)
				@teams = @q_teams.result.order("name").page params[:page_2]
			else
				@teams = Team.order("name").page params[:page_2]
			end

			if(params[:q][:headline_cont] != nil)
		  	@news = @q_news.result.order("created_at").page params[:page_3]
		  else
		  	@news = News.order("created_at").page params[:page_3]
		  end

		else
			@users = User.order("username").page params[:page_1]
			@teams = Team.order("name").page params[:page_2]
		  @news = News.order("created_at").page params[:page_3]
		end

  end

end
