module Yodeler
  class Configuration
    include ActiveSupport::Configurable
    config_accessor(:test) { false }
    config_accessor(:default_states){
      {
        unread: 0,
        read:   1
      }
    }
  end
end