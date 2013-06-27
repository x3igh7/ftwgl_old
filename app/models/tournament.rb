class Tournament < ActiveRecord::Base
  attr_accessible :description, :name, :rules
end
