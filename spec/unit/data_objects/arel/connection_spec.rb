require 'spec_helper'

describe DataObjects::Arel::Connection do

  subject   { described_class.new(uri) }
  let(:uri) { Addressable::URI.parse('test://test@127.0.0.1/test') }

  describe '#visitor' do
    it 'should return a visitor' do
      expect(subject.visitor).to be_a Arel::Visitors::ToSql
    end
  end

  describe '#quote_table_name' do
    it 'should quote correctly' do
      expect(subject.quote_table_name('widget_orders')).to eq '"widget_orders"'
    end
  end

  describe '#quote_column_name' do
    it 'should quote correctly' do
      expect(subject.quote_column_name('widget_id')).to eq '"widget_id"'
    end
  end

end
