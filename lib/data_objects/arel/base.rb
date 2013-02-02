module DataObjects
  module Arel
    ConnectionNotEstablished = Class.new(StandardError)

    # A class that quacks just enough like ActiveRecord::Base to satisfy Arel.
    class Base
      def self.establish_connection(spec)
        @@uri = spec.fetch(:uri)
        connection
      end

      def self.connection
        raise ConnectionNotEstablished, 'DataObjects::Arel::Base.establish_connection has not yet been called.' unless defined?(@@uri)
        @connection = Connection.new(@@uri)
        @connection
      end

      def self.table_name=(table)
        # no-op
      end
    end
  end
end
