class Api::UsersController < ApplicationController
	PAGESIZE = 5
	
	def index
		page = params[:page].to_i
		#extremely inefficient pagination
		@users = User.order(:username)[ (page - 1) * PAGESIZE, PAGESIZE ]
		@response = {}
		@response[:users] = []
		@users.each do |user| 
			@response[:users] << { :id => user.id, :username => user.username, :email => user.email, :banned => user.banned? }
		end
		@response[:total_pages] = ( ( User.count - 1) / PAGESIZE ).floor + 1
		render :json => @response
		return
 	end
end
