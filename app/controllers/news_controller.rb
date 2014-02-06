class NewsController < ApplicationController

  def show
    @news = News.find(params[:id])
    @comments = @news.comments
  end

end

