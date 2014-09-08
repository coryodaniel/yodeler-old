module Yodeler
  class Event < ActiveRecord::Base
    serialize :payload, Hash
    
    validates_presence_of :event_type
    belongs_to :event_type, class_name: "Yodeler::EventType::Base", foreign_key: :yodeler_event_type_id

    has_many :subscriptions, dependent: :destroy, class_name: "Yodeler::Subscription", foreign_key: :yodeler_event_id
    has_many :notifications, through: :subscriptions
    #has_many :subscribers, through: :subscriptions, as: :subscriber

    def duration
      finished_at - started_at if finished_at.present? and started_at.present?
    end
  end
end