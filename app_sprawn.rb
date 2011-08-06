class AppSprawn

  def self.setup web_socket
    App.dom_on_sockets = DomOnSockets.new(web_socket)

    web_socket.onopen do
      MyApp.new.setup_app
    end

  end

end
