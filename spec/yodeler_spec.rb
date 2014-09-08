require 'spec_helper'

describe Yodeler do
  describe '.register' do
    context 'when a block is provided' do
      before do
        Yodeler.register(:rock_show){|config|
          config.states = {
            not_started:  0,
            started:      1,
            finished:     2
          }
        }        
      end

      it 'creates the event type model' do
        expect(
          defined?(Yodeler::EventType::RockShowEventType)
        ).to eq 'constant'
      end

      it 'stores the registration' do
        expect(
          Yodeler::EventType::RockShowEventType.configuration.states
        ).to include({
          not_started:  0,
          started:      1,
          finished:     2
        })
      end
    end

    context 'when a block is not provided' do
      before{
        Yodeler.register(:handstand_performed)
      }

      it 'stores the registration' do
        Yodeler.registrations.include?(:handstand_performed)
      end

      it 'creates an event type model' do
        expect(
          defined?(Yodeler::EventType::HandstandPerformedEventType)
        ).to eq 'constant'
      end       
    end   
    
    describe 'configuring an event type' do
      pending
      # pending 'accepting and applying states' 
      # pending 'accepting and applying notify_if' 
      # pending 'accepting and applying dispatch_if' 
      # pending 'accepting and applying destroy_notification_if' 
      # pending 'accepting and applying after_transition' 
      # pending 'accepting and applying async' 
      # pending 'accepting and applying sms' 
      # pending 'accepting and applying email' 
      # pending 'accepting and applying websocket' 
    end

  end

  describe '.dispatch' do
    context 'when the event type is not registered' do
      pending 'dispatches the NoopEventType'
    end

    context 'when the event type is registered' do
      before{
        Yodeler.register :doorbell
      }
      
      context 'when a payload is present' do
        context 'when its the first dispatch' do
          pending 'creates an event type record'
        end
        pending 'it creates an event with the payload'

        #it{
          #Yodeler.dispatch :doorbell, {number_of_presses: 3}
        #}
      end
      
      pending 'when a payload is not present'
      
      context 'when receiving a block' do
        pending 'benchmarks the duration of the event'
      end
    end
  end
end