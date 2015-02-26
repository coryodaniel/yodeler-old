class CreateYodelerTables < ActiveRecord::Migration
  def change
    create_table :yodeler_event_types do |t|
      t.string :name, null: false # Maps to registered name in DSL
      t.string :type #STI
      t.datetime :created_at
    end

    create_table :yodeler_events do |t|
      t.integer :yodeler_event_type_id, null: false
      t.datetime :started_at
      t.datetime :finished_at
      t.text :payload
      t.datetime :created_at, null: false      
    end

    create_table :yodeler_subscriptions do |t|
      t.integer :yodeler_event_type_id, null: false
      
      # polymorphic, support for whatever type of class is owning the subscription
      t.string :subscriber_type, null: false
      t.integer :subscriber_id, null: false
      
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :yodeler_notifications do |t|
      t.integer :yodeler_event_id, null: false
      t.integer :yodeler_subscription_id, null: false
      t.integer :state
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    # sqlite3 has an index name length limitation of 62(?!) characters
    unless Rails.env.test?
      add_index :yodeler_event_types, :name, unique: true      

      add_index :yodeler_events, :yodeler_event_type_id

      add_index :yodeler_subscriptions, :yodeler_event_type_id
      add_index :yodeler_subscriptions, [:subscriber_id, :subscriber_type]

      add_index :yodeler_notifications, :yodeler_event_id
      add_index :yodeler_notifications, :yodeler_subscription_id
      add_index :yodeler_notifications, :state
    end
  end
end
