require 'em-websocket'
require 'json'

require 'digest/sha1'

#Digest::SHA1.hexdigest 'foo'

elements = ['element','button','textfield','list']

elements.each{|x| require_relative 'lib/elements/'+x }

require_relative 'lib/dom_on_sockets'
require_relative 'lib/app_sprawn'
require_relative 'lib/app'
require_relative 'store'
require_relative 'myapp'

EventMachine.run do
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    AppSprawn.setup ws
  end
end
