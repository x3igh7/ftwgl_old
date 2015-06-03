class Admin::NewsController < AdminController

  def new
    @news = News.new
    @sources = ["General"]
    @tournaments = Tournament.where("active = true").each { |tourny| @sources << tourny.name }
  end

  def create
    @news = News.new(params[:news])
    @source = params[:news][:newsable_id]
    if @source == "General"
      @news.newsable_id = 0
      @news.newsable_type = "General"
    else
      @tournament = Tournament.where(name: "#{@source}")
      @news.newsable_id = @tournament.last.id
      @news.newsable_type = "Tournament"
    end

    @news.user_id = current_user.id

    if @news.save
      flash[:notice] = "News successfully added!"
      redirect_to news_path(@news.id)
    else
      flash[:alert] = "Failed to add news."
      render :new
    end

  end

  def edit
    @news = News.find(params[:id])
    enforce_tournament_admin_news(@news)
    @sources = ["General"]
    @tournaments = Tournament.where("active = true").each { |tourny| @sources << tourny.name }
  end

  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      flash[:notice] = "News successfully added!"
      redirect_to news_path(@news.id)
    else
      flash[:alert] = "Failed to add news."
      render :edit
    end

  end

  def destroy
    @news = News.find(params[:id])
    enforce_tournament_admin_news(@news)

    if @news.delete
      flash[:notice] = "News deleted."
      redirect_to admin_root_path
    else
      flash[:alert] = "Unable to delete News."
      redirect_to admin_root_path
    end
  end

  private

  def enforce_tournament_admin_news(news)
    if current_user.is_tournament_admin? && !current_user.has_role?(:admin)
      news = current_user.admin_news
      if !news.include?(news)
        flash[:alert] = "You don't have sufficient permissions to do that."
        redirect_to admin_root_path
      end
    end
  end

end
