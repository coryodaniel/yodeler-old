module Yodeler
  module EventType
    class Base < ActiveRecord::Base


      self.table_name= "yodeler_event_types"

      validates_presence_of :name
      has_many :events, 
        dependent: :destroy, 
        class_name: "Yodeler::EventType::Base", 
        foreign_key: :yodeler_event_type_id


      def self.yodel!(event_type, payload)
        new_klass = self.new

      end
    end
  end
end