module Yodeler
  class Notification < ActiveRecord::Base
    validates_presence_of :subscription
    belongs_to :subscription, class_name: "Yodeler::Subscription", foreign_key: :yodeler_subscription_id

    delegate :subscriber, to: :subscription
    delegate :event, to: :subscription
    delegate :event_type, to: :event

    def message
      I18n.t("yodeler.event_types.#{event_type_key}.message", event.payload)
    end

    protected
      def event_type_key
        event_type.name.to_sym
      end
  end
end