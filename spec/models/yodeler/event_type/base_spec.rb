require 'spec_helper' 

describe Yodeler::EventType::Base do
  subject{ FactoryGirl.build :event_type }
  it{ should validate_presence_of :name }
  it{ should have_many(:events).dependent(:delete_all) }
  it{ should have_many(:subscriptions).dependent(:delete_all) }

  context 'when inherited' do
    subject{ FactoryGirl.build :doorbell_event_type }
    describe '.table_name' do
      it{ expect(subject.class.table_name).to eq 'yodeler_event_types' }
    end
  end

  describe '.table_name' do
    it{ expect(Yodeler::EventType::Base.table_name).to eq 'yodeler_event_types' }
  end

  describe '.yodel!' do
    context 'when there are subscriptions' do
      let(:event_type_klass){
        Yodeler.register :subscribed_to_event_test
      }

      let(:event_type){
        Yodeler.dispatch :subscribed_to_event_test
      }

      let(:subscription){
        FactoryGirl.create :subscription, yodeler_event_type_id: event_type.id
      }
      

      it 'dispatches a notification' do
        expect{
          Yodeler.dispatch(subscription.event_type.name.to_sym)
        }.to change(Yodeler::Notification, :count).by(1)
      end

      it 'sets the notifications state' do
        Yodeler.dispatch(subscription.event_type.name.to_sym)
        expect( Yodeler::Notification.first.state ).to eq :unread
      end
    end
  end
end