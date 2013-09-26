#set_rankings_spec.rb

describe "set_ranks" do
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:admin) { FactoryGirl.create(:user) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as admin
  end

  context "of teams in tournament" do

    it "and shows teams in tournaments" do
      visit edit_admin_rank_path(tournament)
    end
  end

end
