require 'spec_helper'

describe Yodeler::Subscription do
  subject{ FactoryGirl.build :subscription }
  it { should validate_presence_of :event_type }
  it { should validate_presence_of :subscriber }
  it { should belong_to(:subscriber) }
  it { should belong_to(:event_type) }  
  it { should have_many(:notifications) }
  
  describe '.table_name' do
    it{ expect(Yodeler::Subscription.table_name).to eq 'yodeler_subscriptions' }
  end

  pending 'callbacks'
  pending 'thresholding'
end