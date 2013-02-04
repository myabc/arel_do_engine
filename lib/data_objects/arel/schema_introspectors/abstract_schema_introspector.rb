module DataObjects
  module Arel
    class AbstractSchemaIntrospector
      include AbstractType, Quoting

      abstract_method :tables, :columns, :primary_key
      attr_reader     :uri

      def initialize(uri)
        @uri = uri
      end

      protected

      def with_connection
        connection = DataObjects::Connection.new(uri)
        yield(connection)
      ensure
        connection.close if connection
      end

    end
  end
end
