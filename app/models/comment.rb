class Comment < ActiveRecord::Base
	MAX_LENGTH = 8000
	attr_accessible :content, :user, :user_id
	belongs_to :commentable, :polymorphic => true
	belongs_to :user, :class_name => "User"

	validates_presence_of :content, :user_id
	validate :is_of_valid_length

	def is_of_valid_length
		if content.empty? or content.length > MAX_LENGTH
			errors.add(:content, "cannot be empty")
		end
		if content.length > MAX_LENGTH
			errors.add(:content, "cannot exceed " + MAX_LENGTH + " characters")
		end
	end
end
