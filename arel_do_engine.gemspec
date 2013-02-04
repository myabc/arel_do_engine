# -*- encoding: utf-8 -*-
# require File.expand_path('../lib/data_mapper/mapper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "arel_do_engine"
  gem.description   = "arel_do_engine"
  gem.summary       = "arel_do_engine"
  gem.authors       = 'Alex Coles'
  gem.email         = 'alex@alexbcoles.com'
  gem.homepage      = 'http://datamapper.org'
  gem.require_paths = [ "lib" ]
  gem.version       = '0.0.1'
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")

  gem.add_dependency 'arel',         '~> 3.0'
  gem.add_dependency 'data_objects', '~> 0.10.10'
  gem.add_dependency 'abstract_type','~> 0.0.2'
end
