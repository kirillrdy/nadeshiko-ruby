require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require_relative 'lib/activerecord'

desc 'Drop All'
task :destroy_all do
  require './app/models/movie'
  Movie.destroy_all
end
