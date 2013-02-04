require 'spec_helper'

describe DataObjects::Arel::SchemaIntrospectors, '.for' do

  let(:uri) { Addressable::URI.parse(uri_str)                 }
  subject   { DataObjects::Arel::SchemaIntrospectors.for(uri) }

  context 'for a SchemaIntrospector that exists' do
    class DataObjects::Arel::TestsqlSchemaIntrospector
      def initialize(url); end
    end

    let(:uri_str) { 'testsql://test@127.0.0.1/test' }

    it { should be_an_instance_of(DataObjects::Arel::TestsqlSchemaIntrospector) }
  end

  context 'for a SchemaIntrospector that does not exist' do
    let(:uri_str) { 'nosql://test@127.0.0.1/test'   }

    it 'should raise an UnknownSchemaIntrospector Error' do
      expect { subject }.to raise_error(DataObjects::Arel::UnknownSchemaIntrospector)
    end
  end

end
