require 'spec_helper'

describe DataObjects::Arel::ConnectionAdapter, '#update' do
  include_context 'connection adapters'

  # context 'with the wrong number of arguments' do
  #   specify { expect{subject.update}.to raise_error(ArgumentError) }
  # end

  context 'called correctly' do
    let(:affected_rows)  { 38 }

    let(:update_manager) do
      Arel::UpdateManager.new(subject).tap do |manager|
        table = Arel::Table.new(:music)
        manager.set([[table[:played], true]])
        manager
      end
    end

    before do
      command.should_receive(:execute_non_query).and_return(result)
      connection.should_receive(:create_command).with(an_instance_of(String))
                                                .and_return(command)
    end

    context 'with a SQL statement' do
      it 'should work with a SQL String' do
        expect(subject.update('UPDATE music SET played = 1')).to be(38)
      end
    end

    context 'with an Arel AST' do
      it 'should work' do
        expect(subject.update(update_manager)).to be(38)
      end
    end

  end
end
