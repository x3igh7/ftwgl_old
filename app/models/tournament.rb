class Tournament < ActiveRecord::Base
  attr_accessible :description, :name, :rules

  validates_presence_of :name
end
