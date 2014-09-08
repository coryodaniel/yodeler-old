module Yodeler
  class Event < ActiveRecord::Base
    serialize :payload, Hash
    
    validates_presence_of :event_type
    
    belongs_to :event_type, class_name: "Yodeler::EventType::Base", foreign_key: :yodeler_event_type_id
    has_many :notifications, class_name: "Yodeler::Notification", foreign_key: :yodeler_event_id

    delegate :subscriptions, to: :event_type

    def duration
      finished_at - started_at if finished_at.present? and started_at.present?
    end
  end
end