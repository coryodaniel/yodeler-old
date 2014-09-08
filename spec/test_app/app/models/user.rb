class User < ActiveRecord::Base
  has_many :dogs

  # The name of the yodler_subscriptions assocation
  listens_to_yodler :subscriptions
end