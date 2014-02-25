class Admin::UsersController < AdminController

  def edit
    @user = User.find(params[:id])
    if @user.has_role?(:admin)
      @user_role = "admin"
    else
      @user_role = "user"
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank? #so that devise will validate and we dont set a blank password
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update_attributes(params[:user])
      redirect_to admin_root_path
    else
      flash[:alert] = "Unable to update user."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.delete
      flash[:notice] = "User deleted."
      redirect_to admin_root_path
    else
      flash[:alert] = "Unable to delete User."
      render :edit
    end
  end

  def ban
    @user = User.find(params[:user_id])
    @user.roles << :banned
    if @user.save
      flash[:notice] = "Successfully banned " + @user.username + " (user #" + String(@user.id) + ")"
      redirect_to admin_root_path
    else
      flash[:alert] = "Could not ban " + @user.username + " (user #" + String(@user.id) + ")"
      render :edit
    end
  end

  def unban
    @user = User.find(params[:user_id])
    @user.roles.delete(:banned)
    if @user.save
      flash[:notice] = "Successfully unbanned " + @user.username + " (user #" + String(@user.id) + ")"
      redirect_to admin_root_path
    else
      flash[:alert] = "Could not unban " + @user.username + " (user #" + String(@user.id) + ")"
      render :edit
    end
  end

end
