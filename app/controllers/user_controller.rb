class UserController < ApplicationController
  def show
    @user = User.find(params[:id])

    if !user_signed_in?
      redirect_to root_path, :alert => "Need to sign in to visit user profiles."
    end
  end
end
