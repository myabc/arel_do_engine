require 'data_objects/arel/schema_introspectors/abstract_schema_introspector'
require 'data_objects/arel/schema_introspectors/mysql_schema_introspector'
require 'data_objects/arel/schema_introspectors/postgres_schema_introspector'
require 'data_objects/arel/schema_introspectors/sqlite3_schema_introspector'

module DataObjects
  module Arel
    UnknownSchemaIntrospector = Class.new(StandardError)

    module SchemaIntrospectors

      def self.for(uri)
        scheme = uri.scheme
        clazz  = DataObjects::Arel.const_get("#{scheme.capitalize}SchemaIntrospector")
        clazz.new(uri)
      rescue NameError
        raise UnknownSchemaIntrospector
      end
    end
  end
end
