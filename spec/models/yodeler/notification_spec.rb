require 'spec_helper'

describe Yodeler::Notification do
  subject{ FactoryGirl.build :notification }
  it { should validate_presence_of :subscription }
  it { should belong_to(:subscription) }
  it { should delegate_method(:event).to(:subscription) }  
  it { should delegate_method(:subscriber).to(:subscription) }  

  describe '#message' do
    it 'gets the message from i18n locale file' do
      expect(subject.message). to eq "Someone rang the doorbell 9 times."
    end
    it 'is the event name downcased and underscored' do
      expect(subject.send(:event_type_key)).to eq :doorbell

    end
  end

  pending 'callbacks'

  describe '.table_name' do
    it{ expect(Yodeler::Notification.table_name).to eq 'yodeler_notifications' }
  end  

  describe 'relationships' do
    subject{ FactoryGirl.create :notification }
    
    it{
      expect(subject.event_type).to eq Yodeler::EventType::DoorbellEventType.first
    }

    it{
      expect(subject.subscriber).to eq User.first
    }

    it{
      expect(subject.subscription).to eq Yodeler::Event.first.subscriptions.first
    }

    it{
      expect(subject).to eq Yodeler::Event.first.notifications.first
    }

    it{
      expect(subject.event).to eq Yodeler::Event.first
    }    
  end
end