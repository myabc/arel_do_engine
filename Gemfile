source :rubygems

gemspec

group :test do
  gem 'do_postgres', '~> 0.10.10'
  gem 'randexp'
end

group :development do
  gem 'devtools', :github => 'datamapper/devtools'
  eval File.read('Gemfile.devtools')
end
