require 'spec_helper'

class MockBunnySession
  def start
  end

  def create_channel
  end
end

describe Columbo do
  it 'has a version number' do
    expect(Columbo::VERSION).not_to be nil
  end

  describe(:clients) do

    context(:http) do
      it 'a nil push url raise an error' do
        expect { Columbo::Client::HTTP.new(@resource_url) }.to raise_error(ArgumentError, 'Please provide a push url')
      end

      context(:raisings) do
        before do
          @client = Columbo::Client::HTTP.new('http://columbo/push', open_timeout: 5, read_timeout: 10)
        end

        it 'custom values for timeouts override default timeouts values' do
          expect(@client.instance_variable_get('@open_timeout')).to eq(5)
          expect(@client.instance_variable_get('@read_timeout')).to eq(10)
        end

        it 'publish (no bang) should not raise an error when publishing failed' do
          allow(@client).to receive(:publish_event) { raise 'error' }
          expect { @client.publish({}) }.not_to raise_error()
        end
      end
    end

    context(:amqp) do
      before do
        @client = Columbo::Client::AMQP.new('amqp://rabbitmq')
      end

      it 'no call to exchange method should raise an error when publish attemp' do
        expect { @client.publish!({}) }.to raise_error(RuntimeError, 'No exchange has been configurated for the Columbo Client')
      end

      it 'should raise when no block is given while configurate the exchange' do
        @client.instance_variable_set('@connection', MockBunnySession.new)
        expect { @client.exchange 'exchange_name' }.to raise_error(ArgumentError, 'Please provide a block to configure the exchange')
      end
    end
  end
end
