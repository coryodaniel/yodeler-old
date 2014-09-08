require "yodeler/engine"

module Yodeler
  autoload :Configuration,        'yodeler/configuration'
  autoload :EventType,        'yodeler/models/event_type'
  autoload :Event,            'yodeler/models/event'
  autoload :Subscription,     'yodeler/models/subscription'
  autoload :Notification,     'yodeler/models/notification'
  autoload :ListensToYodler,  'yodeler/listens_to_yodler'
  autoload :EventType,        'yodeler/models/event_type'

  mattr_accessor :registrations
  self.registrations = []

  # Configuring the yodeler gem
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end  

  # Set the ActiveRecord table name prefix to yodeler_
  #
  # This makes 'events' into 'yodeler_events' and also respects any
  # 'global' table_name_prefix set on ActiveRecord::Base.
  def self.table_name_prefix
    "#{ActiveRecord::Base.table_name_prefix}yodeler_"
  end  

  # Creates an event_type model e.g.: Yodeler::#{event_type}EventType < Yodeler::EventType::Base
  # 
  # @note 
  #   you could also create your own class inheriting #{Yodeler::EventType::Base}
  def self.register(event_type,&block)
    event_type_klass = Yodeler.define_event_type(event_type)
    
    if block_given?
      yield event_type_klass.configuration
    end

    Yodeler.registrations << event_type    
  end  

  def self.dispatch(event_type, payload={})
    event_type_klass = Yodeler.get_class(event_type) rescue Yodeler::EventType::Noop

    event_type_klass.yodel! payload
  end

  def self.get_class(event_type) 
    klass_name = Yodeler.event_type_class_name(event_type)
    "Yodeler::EventType::#{klass_name}".constantize
  end

  # # all event types defunct or not
  # def self.event_types
  # end

  # # all registered event types
  # def self.registered_event_types
  # end

  # Clears all the registrations and removes the EventType classes
  def self.flush_registrations!
    Yodeler.registrations.each do |event_type|
      Yodeler.undefine_event_type(event_type)
    end
    Yodeler.registrations = []
  end

  private
    def self.event_type_class_name(event_type)
      "#{event_type.to_s.classify}EventType"
    end

    def self.undefine_event_type(event_type)
      if defined?( Yodeler.get_class(event_type) ) == 'constant'
        Yodeler::EventType.instance_eval{
          remove_const( event_type.to_s.classify.to_sym )
        }
      end
    end

    def self.define_event_type(event_type)
      undefine_event_type(event_type)
      
      # Define an ancestor event type of Yodeler::EventType::Base and
      #   add AS Configurable to it
      new_event_type_class = Class.new(Yodeler::EventType::Base) do
      end

      # Define the event type class, e.g.: Yodeler::EventType::UserViewedEventType
      Yodeler::EventType.const_set(Yodeler.event_type_class_name(event_type), new_event_type_class)
    end

  # def self.cleanup!(hard=false)
  #   # defunct or delete any event_types, et al that aren't currently registered
  #   if hard
  #   else
  #   end
  # end
end