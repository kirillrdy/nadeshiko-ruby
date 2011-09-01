require 'bundler/setup'

require 'nadeshiko'
require 'active_record'

ENV['RAILS_ENV'] ||= 'development'
config = YAML.load_file('db/config.yml')[ENV['RAILS_ENV']]
ActiveRecord::Base.establish_connection(config)

require_relative 'models/issue'
