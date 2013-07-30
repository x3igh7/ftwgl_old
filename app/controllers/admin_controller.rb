class AdminController < ApplicationController
	before_filter :enforce_permissions
	
	def enforce_permissions
		if (not user_signed_in?) or (not current_user.has_role?(:admin))
			redirect_to root_path
		end
	end
	
	def cpanel
	end
	
	def find_user
		@users = User.find(:all)
		@response = [] 
		@users.each do |user| 
			@response << { :id => user.id, :username => user.username, :email => user.email, :banned => user.banned? }
		end
		render :json => @response
		return
 	end
	
	def ban_user
		@user = User.find(params[:id])
		@user.roles << :banned
		if @user.save
			flash[:notice] = "Successfully banned " + @user.username + " (user #" + String(@user.id) + ")"
		else
			flash[:alert] = "Could not ban " + @user.username + " (user #" + String(@user.id) + ")"
		end
		redirect_to :action => :cpanel
	end
	
	def unban_user
		@user = User.find(params[:id])
		@user.roles.delete(:banned)
		if @user.save
			flash[:notice] = "Successfully unbanned " + @user.username + " (user #" + String(@user.id) + ")"
		else
			flash[:alert] = "Could not unban " + @user.username + " (user #" + String(@user.id) + ")"
		end
		redirect_to :action => :cpanel
	end
	
	def find_tournament
		@tournaments = Tournament.find(:all)
		render :json => @tournaments
	end
end
