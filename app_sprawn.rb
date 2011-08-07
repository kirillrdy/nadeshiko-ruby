class AppSprawn

  def self.setup web_socket

    web_socket.onopen do
      dom_on_sockets = DomOnSockets.new(web_socket)
      app = MyApp.new dom_on_sockets
      app.setup_app
    end

  end

end
