require 'spec_helper'

describe DataObjects::Arel::ConnectionAdapter, '#delete' do
  include_context 'connection adapters'

    let(:statement)     { %q(DELETE FROM "ebooks" WHERE "ebooks"."author" = 'Orwell') }
    let(:affected_rows) { 1984 }
    let(:delete_manager) do
      Arel::DeleteManager.new(subject).tap do |manager|
        table   = Arel::Table.new(:ebooks)
        manager.from(table)
        manager.where(table[:author].eq('Orwell'))
      end
    end

    before do
      command.should_receive(:execute_non_query).and_return(result)
      connection.should_receive(:create_command).with(statement)
                                                .and_return(command)
    end

    context 'with a SQL statement' do
      it 'should return the number of affected rows' do
        expect(subject.delete(statement)).to be(1984)
      end
    end

    context 'with an Arel AST' do
      it 'should return the number of affected rows' do
        expect(subject.delete(delete_manager)).to be(1984)
      end
    end

end
