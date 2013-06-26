class Membership < ActiveRecord::Base
  attr_accessible :user, :role, :team, :active

  validates_presence_of :team, :user, :role
  validates_inclusion_of :active, :in => [true, false]
  validates_inclusion_of :role, :in => ['owner', 'member']

  belongs_to :user
  belongs_to :team
end
