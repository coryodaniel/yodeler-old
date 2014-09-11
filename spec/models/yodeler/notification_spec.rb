require 'spec_helper'

describe Yodeler::Notification do
  let(:event){
    FactoryGirl.create(:event, event_type: FactoryGirl.create(:doorbell_event_type))
  }
  subject{ 
    FactoryGirl.create :notification, event: event 
  }
  it { should validate_presence_of :subscription }
  it { should belong_to(:subscription) }
  it { should validate_presence_of :event }
  it { should belong_to(:event) }  
  it { should delegate_method(:event_type).to(:event) }  
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
    let(:event){
      FactoryGirl.create :event, 
        event_type: FactoryGirl.create(:doorbell_event_type)
    }

    let(:subscription){
      FactoryGirl.create :subscription, 
        subscriber: FactoryGirl.create(:user), 
        event_type: event.event_type
    }

    subject{ 
      FactoryGirl.create :notification, event: event, subscription: subscription
    }
    
    it{
      expect(subject.event_type.name.to_s).to eq Yodeler::EventType::DoorbellEventType.first.name.to_s
      expect(subject.event_type.name.to_s).to eq subject.event.event_type.name.to_s
      expect(subject.subscriber).to eq User.first
      expect(subject.subscription).to eq Yodeler::Event.first.subscriptions.first
      expect(subject).to eq Yodeler::Event.first.notifications.first
      expect(subject.event).to eq Yodeler::Event.first
    }    
  end
end