module DataObjects
  module Arel
    class Column < Struct.new(:name, :type)
    end

    class ConnectionAdapter
      attr_accessor :visitor
      attr_reader   :uri

      def initialize(uri)
        @uri = uri
      end

      def visitor
        @visitor ||= ::Arel::Visitors::PostgreSQL.new(self)
      end

      def tables(name = nil)  # name param not implemented
        with_connection do |connection|
          schemas = schema_search_path.split(/,/).map { |p| quote(p) }.join(',')
          command = connection.create_command(<<-SQL)
            SELECT tablename
              FROM pg_tables
             WHERE schemaname IN (#{schemas})
          SQL
          reader = command.execute_reader
          tables = reader.map { |row| row.values.first }
          reader.close
          tables
        end
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

      def columns(table_name, message = nil)
        with_connection do |connection|
          command = connection.create_command(<<-SQL)
            SELECT a.attname, format_type(a.atttypid, a.atttypmod), d.adsrc, a.attnotnull
              FROM pg_attribute a LEFT JOIN pg_attrdef d
                ON a.attrelid = d.adrelid AND a.attnum = d.adnum
             WHERE a.attrelid = '#{quote_table_name(table_name)}'::regclass
               AND a.attnum > 0 AND NOT a.attisdropped
             ORDER BY a.attnum
          SQL
          reader  = command.execute_reader
          columns = reader.map {
            |row| Column.new(row['attname'], row['format_type'])
          }
          reader.close
          columns
        end
      end

      def primary_key(table)
        with_connection do |connection|
          command = connection.create_command(<<-SQL)
            SELECT attr.attname
            FROM   pg_attribute attr
            INNER JOIN pg_constraint cons ON attr.attrelid = cons.conrelid AND attr.attnum = cons.conkey[1]
            WHERE cons.contype = 'p'
              AND cons.conrelid = '#{quote_table_name(table)}'::regclass
          SQL
          reader  = command.execute_reader
          reader.next!
          row = reader.values
          reader.close

          row && row.first
        end
      end

      def schema_search_path
        @schema_search_path ||= begin
          with_connection do |connection|
            reader = connection.create_command('SHOW search_path').execute_reader
            reader.next!
            search_path = reader.values.first
            reader.close
            search_path
          end
        end
      end

      def table_exists?(name)
        tables.include?(name.to_s)
      end

      def quote_table_name(name)
        "\"#{name.to_s}\""
      end

      def quote_column_name(name)
        "\"#{name.to_s}\""
      end

      def schema_cache
        self
      end

      def quote thing, column = nil
        if column && column.type == :integer
          return 'NULL' if thing.nil?
          return thing.to_i
        end

        case thing
        when true
          "'t'"
        when false
          "'f'"
        when nil
          'NULL'
        when Numeric
          thing
        else
          "'#{thing}'"
        end
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

    end

  end
end
