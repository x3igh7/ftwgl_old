class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_sidebar, :enforce_ban

  def load_sidebar
    if user_signed_in?
      @sidebar_user = current_user
      @sidebar_teams = @sidebar_user.teams
      @sidebar_tournaments = @sidebar_user.tournaments
      @sidebar_matches = @sidebar_user.get_upcoming_matches
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def enforce_ban
    if user_signed_in? and current_user.banned?
      sign_out current_user
      redirect_to root_path, :notice => 'Your account has been suspended.'
    end
  end
end
