class Membership < ActiveRecord::Base
  attr_accessible :user, :role, :team, :active

  validates_presence_of :team, :user, :role
  validates_inclusion_of :active, :in => [true, false]
  validates_inclusion_of :role, :in => ['owner', 'member']
  validates_uniqueness_of :user_id, scoped_to: :team_id

  belongs_to :user
  belongs_to :team

  class << self
    def of_role(role)
      where(role: role)
    end
  end
end
