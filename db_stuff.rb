require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection :host => 'localhost', :database => 'dom_on_sockets', :adapter => 'mysql2'
require './models/movie'

Movie.destroy_all
