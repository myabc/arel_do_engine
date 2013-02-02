require 'spec_helper_integration'

describe 'Basic integraton with Arel' do

  before(:all) do
    setup_db

    arel_base = DataObjects::Arel::Base
    arel_base.establish_connection(:uri => CONFIG['postgres'])
    Arel::Table.engine = Arel::Sql::Engine.new(arel_base)
  end

  context 'a table that does not exist' do
    it 'should raise a DataObjects Error' do
      relation  = Arel::Table.new(:non_existent)
      expect { relation.columns }.to raise_error(DataObjects::SyntaxError)
    end
  end

  context 'a table that exists' do
    let(:table) { Arel::Table.new(:users) }

    it 'name' do
      expect(table.name).to eq 'users'
    end

    it 'table_name' do
      expect(table.table_name).to eq 'users'
    end

    it 'columns' do
      expect(table.columns).to have(3).columns
      expect(table.columns.first.name).to eq :id
    end
  end
end
