module Yodeler
  module EventType
    autoload :Base, "yodeler/models/event_types/base"
    autoload :NoopEventType, "yodeler/models/event_types/noop_event_type"
  end
end