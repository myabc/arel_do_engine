require 'forwardable'

module DataObjects
  module Arel
    class Column < Struct.new(:name, :type)
    end

    class ConnectionAdapter
      include ::DataObjects::Arel::Quoting
      extend Forwardable

      attr_reader     :visitor_class
      attr_reader     :uri
      def_delegators  :introspector, :tables, :columns, :primary_key

      def initialize(uri, visitor_class = nil)
        @uri            = parse_uri(uri)
        @visitor_class  = visitor_class || determine_visitor(@uri.scheme)
      end

      def visitor
        @visitor      ||= visitor_class.new(self)
      end

      def introspector
        @introspector ||= SchemaIntrospectors.for(uri)
      end

      def columns_hash
        @columns_hash ||= begin
          hash = {}
          tables.each do |table|
            hash[table] = Hash[columns(table).map { |x| [x.name, x] }]
          end
          hash
        end
      end

      def table_exists?(name)
        tables.include?(name.to_s)
      end

      def schema_cache
        self
      end

      def insert(arel, name = nil, pk = nil, id_value = nil, sequence_name = nil, binds = [])
        with_connection do |connection|
          command   = connection.create_command(to_sql(arel))
          insert_id = command.execute_non_query
        end
        id_value
      end

      def delete(arel, name = nil, binds = [])
        with_connection do |connection|
          connection.create_command(to_sql(arel)).execute_non_query
        end.affected_rows
      end

      def update(arel, name = nil, binds = [])
        with_connection do |connection|
          connection.create_command(to_sql(arel)).execute_non_query
        end.affected_rows
      end

      def execute(sql, name = nil)
        with_connection do |connection|
          command = connection.create_command(sql)
          command.execute_reader
        end
      end

      # Converts Arel AST to SQL
      def to_sql(arel, binds = [])
        if arel.respond_to?(:ast)
          visitor.accept(arel.ast) do
            quote(*binds.shift.reverse)
          end
        else
          arel
        end
      end

      private

      def with_connection
        connection = DataObjects::Connection.new(uri)
        yield(connection)
      ensure
        connection.close if connection
      end

      def parse_uri(uri)
        DataObjects::URI::parse(uri)
      end

      def determine_visitor(scheme)
        case scheme
        when /^Postgres/i
          ::Arel::Visitors::PostgreSQL
        when /^MySQL/i
          ::Arel::Visitors::MySQL
        when /^SQLite/i
          ::Arel::Visitors::SQLite
        else
          ::Arel::Visitors.const_get("#{scheme.capitalize}")
        end
      end

    end
  end
end
