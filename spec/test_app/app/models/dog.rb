require 'yodeler/listens_to_yodler'
class Dog < ActiveRecord::Base
  belongs_to :user
  listens_to_yodler
end