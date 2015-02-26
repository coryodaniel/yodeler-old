$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "yodeler/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "yodeler"
  s.version     = Yodeler::VERSION
  s.authors     = ["Cory O'Daniel"]
  s.email       = ["yodel@coryodaniel.com"]
  s.homepage    = "http://github.com/coryodaniel/yodeler"
  s.summary     = "Subscribable database-stored event notifications for Rails"
  s.rubyforge_project = "yodeler"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "railties"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency 'byebug'
end
