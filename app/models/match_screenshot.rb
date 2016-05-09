class MatchScreenshot < ActiveRecord::Base
  attr_accessible :match, :user, :image
  validates_presence_of :match, :user, :image

  belongs_to :match
  belongs_to :user

  mount_uploader :image, MatchScreenshotUploader
end
