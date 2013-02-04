module DataObjects
  module Arel
    module Quoting

      def quote(thing, column = nil)
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

      def quote_table_name(name)
        "\"#{name.to_s}\""
      end

      def quote_column_name(name)
        "\"#{name.to_s}\""
      end

    end
  end
end
