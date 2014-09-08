class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :name, null: false
      t.string :role, null: false, default: 'user'
      t.datetime :created_at
    end

    create_table :dogs do |t|
      t.string :name, null: false
      t.integer :user_id
      t.datetime :created_at
    end
  end
end
