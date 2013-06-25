require 'spec_helper'

describe Membership do
  it { should belong_to :team }
  it { should belong_to :user }

  it { should validate_presence_of :team }
  it { should validate_presence_of :user }
  it { should validate_presence_of :role }
  
end
