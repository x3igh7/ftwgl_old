require 'spec_helper'

describe "Emails" do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:new_user) {FactoryGirl.build(:user)}

  it "sends a confirmation email to the user" do
    prev = ActionMailer::Base.deliveries.count
    visit root_path
    first(:link, "register").click
    fill_in "user_username", with: new_user.username
    fill_in "user_email", with: new_user.email
    fill_in "user_password", with: new_user.password
    fill_in "user_password_confirmation", with: new_user.password_confirmation
    click_on "Create New Account"
    expect(User.last.username).to eq(new_user.username)
    expect(ActionMailer::Base.deliveries.count).to eq(prev + 1)
  end

  it "sends a password reset email to the user", :focus => true do
    prev = ActionMailer::Base.deliveries.count
    visit root_path
    click_on "Forgot your password?"
    fill_in "user_email", with: user.email
    click_on "Send me reset password instructions"
    expect(ActionMailer::Base.deliveries.count).to eq(prev + 1)
  end

end

