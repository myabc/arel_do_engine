require 'randexp'
require 'yaml'

ROOT   = File.expand_path('../..', __FILE__)
CONFIG = YAML.load_file("#{ROOT}/config/database.yml")

MAX_RELATION_SIZE = 10

def setup_db
  DataObjects.logger.set_log('log/do.log', :debug)

  connection = DataObjects::Connection.new(CONFIG['postgres'])

  connection.create_command('DROP TABLE IF EXISTS "laptops"').execute_non_query
  connection.create_command('DROP TABLE IF EXISTS "users"').execute_non_query

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "laptops"
      ( "hardware_id"    SERIAL      NOT NULL PRIMARY KEY,
        "product_name"   VARCHAR(50) NOT NULL
      )
  SQL

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "users"
      ( "id"       SERIAL      NOT NULL PRIMARY KEY,
        "username" VARCHAR(50) NOT NULL,
        "age"      SMALLINT    NOT NULL
      )
  SQL

  connection.close
end
