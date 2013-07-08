require 'spec_helper'

describe Match do
  it { should belong_to :home_team }
  it { should belong_to :away_team }
  it { should belong_to :tournament }
  it { should validate_presence_of :home_team }
  it { should validate_presence_of :away_team } 
  it { should validate_presence_of :week_num }
  it { should validate_presence_of :match_date }
  it { should validate_presence_of :tournament }
  it { should validate_presence_of :home_score }
  it { should validate_presence_of :away_score }
end
