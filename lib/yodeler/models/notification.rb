module Yodeler
  class Notification < ActiveRecord::Base
    validates_presence_of :subscription
    validates_presence_of :event
        
    belongs_to :event, class_name: "Yodeler::Event", foreign_key: :yodeler_event_id
    belongs_to :subscription, class_name: "Yodeler::Subscription", foreign_key: :yodeler_subscription_id

    delegate :event_type, to: :event
    delegate :subscriber, to: :subscription

    def message
      I18n.t("yodeler.event_types.#{event_type_key}.message", event.payload)
    end

    protected
      def event_type_key
        event_type.name.to_sym
      end
  end
end