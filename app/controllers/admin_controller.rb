class AdminController < ApplicationController
	before_filter :enforce_permissions

	def enforce_permissions
		if (not user_signed_in?) or (not current_user.has_role?(:admin) || current_user.has_role?(:tournament_admin))
			redirect_to root_path
		end
	end

end
