class Membership < ActiveRecord::Base
  attr_accessible :user, :role, :team, :active

  validates_presence_of :team, :user, :role

  belongs_to :user
  belongs_to :team
end
