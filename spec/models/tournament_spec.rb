require 'spec_helper'

describe Tournament do
  it { should validate_presence_of(:name) }
  it { should have_many(:tournament_teams) }
  it { should have_many(:teams) }
end
