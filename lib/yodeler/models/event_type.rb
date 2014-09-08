module Yodeler
  module EventType
    autoload :Base, "yodeler/models/event_types/base"
    autoload :Noop, "yodeler/models/event_types/noop"
    class Configuration
      include ActiveSupport::Configurable
      config_accessor(:states) { 
        {
          unread: 0,
          read:   1
        }
      }
    end
    
  end
end