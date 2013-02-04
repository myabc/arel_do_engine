require 'spec_helper'

describe DataObjects::Arel::ConnectionAdapter, '#execute' do
  include_context 'connection adapters'

  before do
    command.should_receive(:execute_reader).and_return(reader)
    connection.should_receive(:create_command).and_return(command)
  end

  it 'should work' do
    expect(subject.execute('SELECT * FROM tables')).to eq reader
  end

end
