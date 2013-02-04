require 'spec_helper'

describe DataObjects::Arel::ConnectionAdapter do

  subject   { described_class.new(uri) }
  let(:uri) { Addressable::URI.parse('test://test@127.0.0.1/test') }

  describe '#visitor' do
    it 'should return a visitor' do
      expect(subject.visitor).to be_a Arel::Visitors::ToSql
    end
  end

end
