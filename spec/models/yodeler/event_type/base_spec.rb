require 'spec_helper' 

describe Yodeler::EventType::Base do
  subject{ FactoryGirl.build :base_event_type }
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
end