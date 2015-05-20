FactoryGirl.define do
  factory :project do
    name 'Project name'
    association :organization
  end
end
