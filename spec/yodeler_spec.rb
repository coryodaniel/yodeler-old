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
    it 'creates an event type record' do
      Yodeler.register :doorbell
      expect{
        Yodeler.dispatch :doorbell
      }.to change(Yodeler::EventType::Base, :count).by(1)
    end

    context 'when the event type is registered' do      
      context 'when a payload is present' do
        before{
          Yodeler.register :doorbell
          Yodeler.dispatch :doorbell, {number_of_presses: 3, press_duration: [1,1,3] }
        }
        let(:event){
          Yodeler::EventType::DoorbellEventType.first.events.first
        }

        it 'creates an event with the payload' do
          expect(event.payload).
            to include(number_of_presses: 3, press_duration: [1,1,3])
        end

        it 'does not set the started_at time' do
          expect(event.started_at).to be nil
        end

        it 'does not set the finished_at time' do
          expect(event.finished_at).to be nil
        end
        #it{
          #Yodeler.dispatch :doorbell, {number_of_presses: 3}
        #}
      end
      
      context 'when a payload is not present' do
        before{
          Yodeler.register :doorbell
          Yodeler.dispatch :doorbell
        }
        let(:event){ Yodeler::EventType::DoorbellEventType.first.events.first }

        it 'creates an event with the payload' do
          expect(event.payload).to eq({})
        end
      end

      context 'when receiving a block' do
        context 'when not yielding the payload' do
          before{
            Yodeler.register :doorbell
            Yodeler.dispatch(:doorbell, number_of_presses: 1) do
              sleep 0.75
            end
          }
          let(:event){ Yodeler::EventType::DoorbellEventType.first.events.first }


          it 'yields the payload to the block' do
            expect(event.payload[:number_of_presses]).to eq 1
          end

          it 'benchmarks the duration of the event' do
            expect(event.started_at).to_not be nil
            expect(event.finished_at).to_not be nil
          end

        end

        context 'when yielding the payload' do
          before{
            Yodeler.register :doorbell
            Yodeler.dispatch(:doorbell, number_of_presses: 1) do |payload|
              # You can set payload options in the block, and it will
              # also benchmark the block in case you want to do something
              # time intentisive
              payload[:press_duration] = 2
              sleep 0.75
            end
          }
          let(:event){ Yodeler::EventType::DoorbellEventType.first.events.first }

          it 'yields the payload to the block' do
            expect(event.payload[:press_duration]).to eq 2
            expect(event.payload[:number_of_presses]).to eq 1
          end

          it 'benchmarks the duration of the event' do
            expect(event.started_at).to_not be nil
            expect(event.finished_at).to_not be nil
          end
        end
      end
    end

    context 'when the event type is not registered' do
      before{
        Yodeler.dispatch :unregistered_thing
      }
      let(:event){ Yodeler::EventType::NoopEventType.first.events.first }

      it 'is the noop event type' do
        expect(event.event_type.name).to eq "noop"
      end
    end    
  end
end