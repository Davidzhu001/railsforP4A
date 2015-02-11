FactoryGirl.define do
  factory :friendship do
    association :user, factory: :user
    association :friend, factory: :user

    factory :pending_friendship do
      state 'pending'
    end

    factory :requested_friendship do
      state 'requested'
    end

    factory :accepted_friendship do
      state 'accepted'
    end
  end

end
