module Yodeler
  module EventType
    class Base < ActiveRecord::Base
      self.table_name= "yodeler_event_types"

      class Configuration
        include ActiveSupport::Configurable
        config_accessor(:states) do
          Yodeler.configuration.default_states
        end
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


      # Logs the occurrence of a {Yodeler::Event} and dispatches notifications
      #
      # @param [Hash] params additional params to log
      # @option params [String] :started_at Benchmark started at time
      # @option params [String] :finished_at Benchmark finished at time
      #
      # @param [Hash] payload Serialized hash, anything you want
      #
      # @return [~Yodeler::EventType::Base] the logged event
      def self.yodel!(params)
        current_event_type  = self.first
        current_event       = current_event_type.events.create(params)

        current_event_type.subscriptions.each do |subscriber|
          subscriber.notifications.create({
            yodeler_event_id: current_event.id
          })
        end

        current_event
      end
    end
  end
end