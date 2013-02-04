require 'spec_helper'

describe DataObjects::Arel::ConnectionAdapter, '#insert' do
  include_context 'connection adapters'

  # context 'with the wrong number of arguments' do
  #   specify { expect{subject.insert}.to raise_error(ArgumentError) }
  # end

  context 'called correctly' do
    let(:insert_manager) do
      Arel::InsertManager.new(subject).tap do |manager|
        table = Arel::Table.new(:tweets)
        manager.into(table)
        manager.insert([[table[:author], '@myabc']])
      end
    end

    before do
      command.should_receive(:execute_non_query).and_return(result)
      connection.should_receive(:create_command).with(an_instance_of(String))
                                                .and_return(command)
    end

    context 'with a SQL statement' do
      it 'should work' do
        expect(subject.insert("INSERT INTO tweets VALUES ('FUD', '@myabc')")).to be_nil
      end

      it 'should provided with an id_value' do
        expect(subject.insert("INSERT INTO tweets VALUES ('wisdom', '@myabc')", 'SQL', nil, 69)).to eq 69
      end
    end

    context 'with an Arel AST' do
      it 'should work' do
        expect(subject.update(insert_manager)).to be(0)
      end
    end

  end
end
