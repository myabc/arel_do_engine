require 'spec_helper'

require 'do_postgres'

require 'db_setup'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
