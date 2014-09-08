require 'rails/generators'
require 'rails/generators/active_record'

module Yodeler
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)
    desc 'Generates (but does not run) a migration to add yodeler tables and an initializer.'

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_yodeler_tables.rb'
    end

    def create_initializer
      copy_file 'initializer.rb', 'config/initializers/yodeler.rb'
    end    

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
