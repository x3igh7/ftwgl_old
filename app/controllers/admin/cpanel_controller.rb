class Admin::CpanelController < AdminController

  def index
    @user = current_user
    @active_tournaments = nil
    @admin_teams = nil
    @admin_news = nil

    if @user.is_tournament_admin?
    	@active_tournaments = @user.admin_tournaments
    	@admin_teams = @user.admin_teams
    	@admin_news = @user.admin_news
    else
 	    @active_tournaments = Tournament.where("active = true")
 	  end

 	  @q_users = User.search(params[:q])
	  @q_teams = Team.search(params[:q])
	  @q_news = News.search(params[:q])

	  if(params[:q] != nil)

		  if(params[:q][:username_or_email_cont] != nil)
		  	@users = @q_users.result.order("username").page params[:page_1]
			else
				@users = User.order("username").page params[:page_1]
			end

			if(params[:q][:name_or_tag_cont] != nil)
		  	if @user.is_tournament_admin?
		  		@teams = @q_teams.result.order("name")

		  		@teams.each_with_index do |t, i|
		  			if !@admin_teams.include?(t)
		  				@teams.delete_at(i)
		  			end
		  		end

		  		@teams = @teams.page params[:page_2]
		  	else
					@teams = @q_teams.result.order("name").page params[:page_2]
				end
			else
				if @user.is_tournament_admin?
					@teams = @admin_teams
				else
					@teams = Team.order("name").page params[:page_2]
				end
			end

			if(params[:q][:headline_cont] != nil)
		  	if @user.is_tournament_admin?
		  		@news = @q_news.result.order("created_at")

		  		@news.each_with_index do |n, i|
			  		if !@admin_news.include?(n)
			  			@news.delete_at(i)
			  		end
		  		end

		  		@news = @news.page params[:page_3]
		  	else
		  		@news = @q_news.result.order("created_at").page params[:page_3]
		  	end
		  else
		  	if @user.is_tournament_admin?
					@news = @admin_news
				else
		  		@news = News.order("created_at").page params[:page_3]
		  	end
		  end

		else
			@users = User.order("username").page params[:page_1]
			@teams = Team.order("name")
			@news = News.order("created_at")

			if @user.is_tournament_admin?

				@news.each_with_index do |n, i|
		  		if !@admin_news.include?(n)
		  			@news.delete_at(i)
		  		end
		  	end

		  	@teams.each_with_index do |t, i|
		  		if !@admin_teams.include?(t)
		  			@teams.delete_at(i)
		  		end
		  	end

			end

			@news = @news.page params[:page_3]
		  @teams = @teams.page params[:page_2]
		end
  end

end
