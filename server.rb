require 'em-websocket'
require 'json'

require 'digest/sha1'

#Digest::SHA1.hexdigest 'foo'

elements = ['element','button','textfield','list','grid']

elements.each{|x| require_relative 'lib/elements/'+x }

require_relative 'lib/dom_on_sockets'
require_relative 'lib/app_sprawn'
require_relative 'lib/app'
require_relative 'stores/movie_store'
require_relative 'myapp'


require 'sinatra/activerecord'
ActiveRecord::Base.establish_connection :host => 'localhost', :database => 'dom_on_sockets', :adapter => 'mysql2'
require_relative 'models/movie'


EventMachine.run do
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    AppSprawn.setup ws
  end
  puts "Server started"
end
