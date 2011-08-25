module Nadeshiko

  class Server

    def self.run application

      EventMachine.run do
        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |web_socket|
          web_socket.onopen do
            dom_on_sockets = DomOnSockets.new(web_socket)
            app = application.new dom_on_sockets
            app.start
          end
        end
        puts "Nadeshiko Server started"
      end

    end

  end

end
