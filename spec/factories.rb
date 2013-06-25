FactoryGirl.define do
  
  factory :team do
    name 'foo'
    tag '[bar]'
  end

  factory :membership do
    team
    user
    role 'user'
  end
end
