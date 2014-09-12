module Yodeler
  module ListensToYodeler
    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      def listens_to_yodeler(subscriptions_assocation_name = :yodeler_subscriptions)
        cattr_accessor :yodeler_subscriptions_name
        self.yodeler_subscriptions_name = subscriptions_assocation_name

        has_many self.yodeler_subscriptions_name, 
          dependent: :destroy, 
          class_name: "Yodeler::Subscription", 
          foreign_key: :subscriber_id
         
        include Yodeler::ListensToYodeler::LocalInstanceMethods
      end
    end
 
    module LocalInstanceMethods;end;
  end
end
 
ActiveRecord::Base.send :include, Yodeler::ListensToYodeler