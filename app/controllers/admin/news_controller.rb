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

    if @news.delete
      flash[:notice] = "News deleted."
      redirect_to admin_root_path
    else
      flash[:alert] = "Unable to delete News."
      redirect_to admin_root_path
    end
  end

end
