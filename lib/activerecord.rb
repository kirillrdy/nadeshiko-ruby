#require 'sinatra/activerecord'
require 'active_record'
ActiveRecord::Base.establish_connection :host => 'localhost', :database => 'dom_on_sockets', :adapter => 'mysql2'
require_relative '../app/models/movie'
