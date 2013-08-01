class Admin::UsersController < AdminController
	def index
		@users = User.find(:all)
		@response = [] 
		@users.each do |user| 
			@response << { :id => user.id, :username => user.username, :email => user.email, :banned => user.banned? }
		end
		render :json => @response
		return
 	end
	
	def update
		@user = User.find(params[:id])
		if params[:user][:password].blank? #so that devise will validate
			params[:user].delete(:password)
			params[:user].delete(:password_confirmation)
		end
		
		if @user.update_attributes(params[:user])
			render :json => { :success => true, :user => @user }
		else
			render :json => { :success => false, :user => @user }
		end
	end
	
	def ban
		@user = User.find(params[:id])
		@user.roles << :banned
		if @user.save
			flash[:notice] = "Successfully banned " + @user.username + " (user #" + String(@user.id) + ")"
		else
			flash[:alert] = "Could not ban " + @user.username + " (user #" + String(@user.id) + ")"
		end
		redirect_to admin_root_path
	end
	
	def unban
		@user = User.find(params[:id])
		@user.roles.delete(:banned)
		if @user.save
			flash[:notice] = "Successfully unbanned " + @user.username + " (user #" + String(@user.id) + ")"
		else
			flash[:alert] = "Could not unban " + @user.username + " (user #" + String(@user.id) + ")"
		end
		redirect_to admin_root_path
	end
end
