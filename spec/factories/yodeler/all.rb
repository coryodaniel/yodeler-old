FactoryGirl.define do
  factory :event, class: Yodeler::Event do
    event_type
    
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
    event_type
    subscriber{ FactoryGirl.create :user }
  end

  factory :notification, class: Yodeler::Notification do
    after(:build) do |notification|
      notification.subscription ||= FactoryGirl.create :subscription
      notification.event ||= FactoryGirl.create :event, event_type: notification.subscription.event_type
    end
  end

  factory :doorbell_event_type, class: Yodeler::EventType::DoorbellEventType do
    type "Yodeler::EventType::DoorbellEventType"
    name :doorbell
  end

  factory :event_type, class: Yodeler::EventType::Base do
    type "Yodeler::EventType::Base"
    name {
      "random_#{rand(1000000000000)}"
    }
  end
end