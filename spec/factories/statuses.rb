FactoryGirl.define do

  factory :status do
    content { Faker::Lorem.sentence }
  end

end
