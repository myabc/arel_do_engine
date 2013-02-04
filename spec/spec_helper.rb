require 'rubygems'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'data_objects/arel'
require 'rspec'

%w(shared support).each do |name|
  Dir[File.expand_path("../#{name}/**/*.rb", __FILE__)].each { |file| require file }
end

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include(SpecHelper)
end
