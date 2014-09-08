module Yodeler
  class Configuration
    include ActiveSupport::Configurable
    config_accessor(:test) { false }
  end
end