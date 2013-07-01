class Tournament < ActiveRecord::Base
  attr_accessible :description, :name, :rules

  validates_presence_of :name

  has_many :tournament_teams
  has_many :teams, through: :tournament_teams
end
