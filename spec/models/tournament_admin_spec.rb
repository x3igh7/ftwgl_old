require 'spec_helper'

describe TournamentAdmin, :focus => true do
	it { should belong_to :tournament }
	it { should belong_to :user }
	it { should validate_presence_of :tournament }
	it { should validate_presence_of :user }
end
