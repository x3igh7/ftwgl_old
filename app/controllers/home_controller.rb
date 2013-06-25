class HomeController < ApplicationController

  def home
    if user_signed_in?
      @teams = User.find(current_user).teams
    end
  end
end
