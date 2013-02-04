shared_context 'connection adapters' do

  subject             { described_class.new(uri)                            }
  let(:uri)           { Addressable::URI.parse('test://test@127.0.0.1/test')}
  let(:connection)    { mock('connection')                                  }
  let(:command)       { mock('command')                                     }
  let(:reader)        { mock('reader')                                      }
  let(:result)        { mock('result', :affected_rows => affected_rows)     }
  let(:affected_rows) { 0                                                   }

  before do
    subject.should_receive(:with_connection).and_yield(connection)
  end

end
