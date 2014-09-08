module Yodeler
  module EventType
    class Base < ActiveRecord::Base
      self.table_name= "yodeler_event_types"

      class Configuration
        include ActiveSupport::Configurable
        config_accessor(:states) { 
          {
            unread: 0,
            read:   1
          }
        }
      end

      def self.configuration
        @configuration ||= Configuration.new
      end

      validates_presence_of :name
      validates_uniqueness_of :name
      
      has_many :events, 
        dependent: :destroy, 
        class_name: "Yodeler::Event", 
        foreign_key: :yodeler_event_type_id

      has_many :subscriptions, 
        dependent: :destroy, 
        class_name: "Yodeler::Subscription", 
        foreign_key: :yodeler_event_type_id


      def self.yodel!(event_type, payload)
        event_type = self.first_or_initialize(name: event_type)

        event_type.events.create(payload: payload)
        new_klass.subscriptions.each do |subscriber|
          # notify the subscriber... subscriber
        end
      end
      
    end
  end
end