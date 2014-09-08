module Yodeler
  class Subscription < ActiveRecord::Base
    validates_presence_of :subscriber, :event_type
    belongs_to :event_type, class_name: "Yodeler::EventType::Base", foreign_key: :yodeler_event_type_id
    belongs_to :subscriber, polymorphic: true

    has_many :notifications, class_name: "Yodeler::Notification", foreign_key: :yodeler_subscription_id
  end
end