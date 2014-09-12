class User < ActiveRecord::Base
  has_many :dogs

  # The name of the yodeler_subscriptions assocation
  listens_to_yodeler :subscriptions, :notifications
end