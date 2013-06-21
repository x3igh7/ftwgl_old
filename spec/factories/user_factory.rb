FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "foo#{n}@example.com"}
    sequence(:username) {|n| "user{n}"}
    password "12345678"
    password_confirmation "12345678"
  end

end
