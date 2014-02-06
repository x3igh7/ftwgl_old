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
      tournament = Tournament.where("name = #{@source}")
      @news.newsable_id = tournament.id
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

  def destroy
  end

end
