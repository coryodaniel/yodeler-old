require 'spec_helper' 

describe Yodeler::EventType::Base do
  subject{ FactoryGirl.build :event_type }
  it{ should validate_presence_of :name }
  it{ should have_many(:events).dependent(:destroy) }
  it{ should have_many(:subscriptions).dependent(:destroy) }

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

      let(:subscription){
        FactoryGirl.create :subscription, event_type: event_type_klass.first
      }
      

      it 'dispatch notification' do
        expect{
          Yodeler.dispatch(subscription.event_type.name.to_sym)
        }.to change(Yodeler::Notification, :count).by(1)
      end
    end
  end
end