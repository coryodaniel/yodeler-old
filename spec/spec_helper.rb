require 'simplecov'
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
#require File.expand_path("../../config/environment", __FILE__)
require File.expand_path("../test_app/config/environment",  __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_girl_rails'
require 'database_cleaner'

#Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

silence_stream(STDOUT) do
  # migrate the test app to set it up
  ActiveRecord::Migrator.migrate File.expand_path("../test_app/db/migrate/", __FILE__)

  # migrate in the yodeler.
  require File.expand_path("../../lib/generators/yodeler/templates/migration",  __FILE__)
  CreateYodelerTables.migrate :up
end

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
#ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = true
  config.order = "random"

  config.before(:each) do
    Yodeler.flush_registrations!
  end

  config.before(:suite) do 
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end  
  end 
end
