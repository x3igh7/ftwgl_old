class TemplatesController < ApplicationController
	TEMPLATES = {
		:MATCHES => { :create => "create_match", :destroy => "destroy_match", :edit => "edit_match", :matches => "matches", :table => "matches_table", :heading => "js_templates/matches_heading", :row => "js_templates/matches_row", :weeks => "matches_weeks", :weekButton => "matches_weeks_button" },
		:TOURNAMENTS => { :create => "create_tournament", :destroy => "destroy_tournament", :edit => "edit_tournament", :tournament => "tournaments" },
		:USERS => { :table => "users_table", :row => "users_row", :heading => "users_heading" }
	}
	
	
	def templates
		templates = Hash.new
		TEMPLATES.each_key do |type|
			templates[type] = {}
			TEMPLATES[type].each_key do |subtype|
				templates[type][subtype] = render :partial => "/application/js_templates/" + TEMPLATES[type][subtype]
			end
		end
		
		render :json => templates
		#render :json => TEMPLATES.each_key do |type|
			
		#	all_rendered[type] = paths.each_with_object({}) do |(subtype, path), rendered|
		#		rendered[subtype] = render :partial => ( "/application/js_templates/" + path )
		#	end
	end
end
