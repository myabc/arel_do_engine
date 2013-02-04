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

      def insert(sql, name = nil)
        with_connection do |connection|
          # FIXME: Why DO we need to call #to_sql here?
          command = connection.create_command(sql.to_sql)
          command.execute_non_query
        end
      end

      def delete(sql, name = nil)
        with_connection do |connection|
          # FIXME: Why DON'T we need to call #to_sql here?
          command = connection.create_command(sql)
          result  = command.execute_non_query
          result.affected_rows
        end
      end

      def update(sql, name = nil)
        with_connection do |connection|
          # FIXME: Why DO we need to call #to_sql here?
          command = connection.create_command(sql.to_sql)
          result  = command.execute_non_query
          result.affected_rows
        end
      end

      def execute(sql)
        with_connection do |connection|
          command = connection.create_command(sql)
          command.execute_reader
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
