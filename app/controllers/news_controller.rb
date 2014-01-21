class NewsController < ApplicationController

def show
  @news = News.find(params[:id])
end

end

