require 'spec_helper_integration'

describe DataObjects::Arel::ConnectionAdapter do

  before(:all) do
    setup_db
  end

  let(:connection) { DataObjects::Arel::ConnectionAdapter.new(CONFIG['postgres']) }

  describe '#tables' do
    it 'should list all given tables for a Connection' do
      expect(connection.tables).to be_an Array
      expect(connection.tables).to include 'users'
    end
  end

  describe '#table_exists?' do
    context 'with a table that does not exist' do
      it 'should return false' do
        expect(connection.table_exists?(:non_existent_table)).to be_false
        expect(connection.table_exists?('non_existent_table')).to be_false
      end
    end

    context 'with a table that exists' do
      it 'should return true' do
        expect(connection.table_exists?(:users)).to be_true
        expect(connection.table_exists?('users')).to be_true
      end

      it 'should recognise case and return false where case is different' do
        # TODO: Determine if this is correct behaviour
        expect(connection.table_exists?('USERS')).to be_false
        expect(connection.table_exists?('Users')).to be_false
      end
    end
  end

  describe '#columns' do
    it 'should list all columns for a given table' do
      expect(connection.columns('users')).to have(3).columns
    end
  end

  describe '#primary_key' do
    it 'should show the primary key for a given table' do
      expect(connection.primary_key('laptops')).to eq 'hardware_id'
    end
  end

end
