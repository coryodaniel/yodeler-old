require 'spec_helper'

describe Yodeler::ListensToYodeler do
  context 'when setting the relationship name' do
    it 'uses subscriptions as the Yodeler::Subscription assocation name' do
      expect(User.new).to have_many(:subscriptions).dependent(:destroy)
    end
  end

  context 'when not setting the relationship name' do
    it 'uses yodeler_subscriptions as the Yodeler::Subscription assocation name' do
      # Dogs dont care about method names.
      expect(Dog.new).to have_many(:yodeler_subscriptions).dependent(:destroy)
    end
  end
end