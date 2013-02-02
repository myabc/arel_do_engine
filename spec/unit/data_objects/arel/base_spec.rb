require 'spec_helper'

describe DataObjects::Arel::Base do

  describe '.connection' do
    it 'should blow up if no connection has been established' do
      expect { described_class.connection }.to raise_error(DataObjects::Arel::ConnectionNotEstablished)
    end
  end

end
