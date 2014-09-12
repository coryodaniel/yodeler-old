require 'yodeler/listens_to_yodeler'
class Dog < ActiveRecord::Base
  belongs_to :user
  listens_to_yodeler
end