module Yodeler
  module EventType
    # The event that is dispatch if an Yodeler.dispatch is called on an event type that
    #   does not exist
    #
    # @example
    #   Yodeler.dispatch :i_dont_exist, my_payload
    #     # => Yodeler.dispatch :noop, my_payload
    class Noop < Yodeler::EventType::Base
    end
  end
end