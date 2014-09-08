require 'spec_helper'
require 'generator_spec/test_case'
require File.expand_path('../../../lib/generators/yodeler/install_generator', __FILE__)

describe Yodeler::InstallGenerator, :type => :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __FILE__)

  after(:all) { prepare_destination } # cleanup the tmp directory

  describe "no options" do
    before(:all) do
      prepare_destination
      run_generator
    end

    it "generates a initializer file for 'yodeler'" do
      expect(destination_root).to have_structure {
        no_file "yodeler.rb"
        directory "config" do
          directory "initializers" do
            file "yodeler.rb" do
              contains 'Yodeler.configure do |config|'
            end
          end
        end
      }
    end
  
    it "generates a migration for creating the 'yodeler' tables" do
      expect(destination_root).to have_structure {
        directory 'db' do
          directory 'migrate' do
            migration 'create_yodeler_tables' do
              contains 'class CreateYodelerTables'
              contains 'def change'
              contains 'create_table :yodeler_events do |t|'
              contains 'create_table :yodeler_subscriptions do |t|'
              contains 'create_table :yodeler_notifications do |t|'
            end
          end
        end
      }
    end
  end
end