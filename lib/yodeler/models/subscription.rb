module Yodeler
  class Subscription < ActiveRecord::Base
    validates_presence_of :subscriber, :event
    belongs_to :event, class_name: "Yodeler::Event", foreign_key: :yodeler_event_id
    belongs_to :subscriber, polymorphic: true

    has_many :notifications, class_name: "Yodeler::Notification", foreign_key: :yodeler_subscription_id
  end
end