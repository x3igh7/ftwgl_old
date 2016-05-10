class MatchScreenshotsController < ApplicationController
  def new
    @screenshot = MatchScreenshot.new
    @match = Match.find(params[:match_id])
  end

  def create
    @screenshot = MatchScreenshot.new(params[:match_screenshot])

    @screenshot.user = current_user
    @screenshot.match = Match.find(params[:match_id])

    @screenshot.save
  end
end
