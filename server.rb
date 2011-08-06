require 'em-websocket'
require 'json'

require 'digest/sha1'

#Digest::SHA1.hexdigest 'foo'

require_relative 'dom_on_sockets'
require_relative 'element'
require_relative 'button'
require_relative 'textfield'
require_relative 'list'
require_relative 'app'
require_relative 'myapp'


EventMachine.run do
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    MyApp.new(ws)
  end
end


