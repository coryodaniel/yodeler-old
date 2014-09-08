FactoryGirl.define do
  factory :event, class: Yodeler::Event do
    association :event_type, factory: :doorbell_event_type
    
    payload({
      number_of_presses: 9,
      was_it_answered: false,
      who_was_home: %w(hamilton chester)
    })

    trait :benchmarked do
      finished_at{ Time.now }
      started_at{ 20.seconds.ago }
    end
  end

  factory :subscription, class: Yodeler::Subscription do
    association :event, factory: :event
    subscriber{ FactoryGirl.create :user }
  end

  factory :notification, class: Yodeler::Notification do
    association :subscription, factory: :subscription
  end

  factory :doorbell_event_type, class: Yodeler::EventType::DoorbellEventType do
    name :doorbell
  end

  factory :base_event_type, class: Yodeler::EventType::Base do
    name :base
  end

  factory :noop_event_type, class: Yodeler::EventType::Noop do
    name :noop
  end
end