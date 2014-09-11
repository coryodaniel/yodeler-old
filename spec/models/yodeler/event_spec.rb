require 'spec_helper'

describe Yodeler::Event do
  subject{ FactoryGirl.build :event }
  it { should validate_presence_of :event_type }
  it { should have_many(:notifications) }
  it { should belong_to(:event_type) }
  it { should serialize(:payload) }
  it { should delegate_method(:subscriptions).to(:event_type)}
  it { should delegate_method(:name).to(:event_type)}
  
  describe '#duration' do
    context 'when benchmark times are present' do
      subject{ FactoryGirl.build :event, :benchmarked }
      it{ expect(subject.duration).to be_within(0.1).of(20) }
    end

    context 'when benchmark times are blank' do
      it{ expect(subject.duration).to be_nil }
    end    
  end

  describe 'callbacks' do
  end

  describe '.table_name' do
    it{ expect(Yodeler::Event.table_name).to eq 'yodeler_events' }
  end  
end