class MatchDemo < ActiveRecord::Base
  attr_accessible :match, :user, :demo
  validates_presence_of :match, :user, :demo

  belongs_to :match
  belongs_to :user

  mount_uploader :image, MatchDemoUploader
end
