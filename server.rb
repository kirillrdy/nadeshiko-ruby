require 'em-websocket'
require 'json'

require 'digest/sha1'

#Digest::SHA1.hexdigest 'foo'

require_relative 'dom_on_sockets'
require_relative 'app'

EventMachine.run do
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    App.new(ws)
  end
end


