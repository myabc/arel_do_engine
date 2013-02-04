require 'spec_helper'

describe DataObjects::Arel::Quoting do

  let(:quoting_class) { Class.new { include DataObjects::Arel::Quoting } }

  subject { quoting_class.new }

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
