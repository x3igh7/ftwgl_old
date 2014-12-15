class TournamentAdmin < ActiveRecord::Base
  attr_accessible :tournament, :user

  validates_presence_of :tournament, :user
  validates_uniqueness_of :user_id, scope: :tournament_id

  belongs_to :user
  belongs_to :tournament
end
