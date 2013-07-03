require 'spec_helper'

describe Matches do
  it { should validate_presence_of :home_team }
  it { should validate_presence_of :away_team } 
  it { should validate_presence_of :week_num }
  it { should validate_presence_of :match_date }
end
