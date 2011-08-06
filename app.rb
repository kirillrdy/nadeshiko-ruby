class App

  class << self
    attr_accessor :dom_on_sockets
  end

  def initialize ws
    App.dom_on_sockets = DomOnSockets.new(ws)
    ws.onopen do
      setup_app
    end
  end

end
