FactoryGirl.define do

  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@treebook.com" }
    password 'treebook2'
    password_confirmation 'treebook2'

    factory :admin do
      admin true
    end
  end

end
