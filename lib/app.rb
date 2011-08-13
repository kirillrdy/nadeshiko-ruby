class App
  attr_accessor :dom_on_sockets
  def initialize dom_on_sockets
    @dom_on_sockets = dom_on_sockets
  end
  
  def alert msg
    @dom_on_sockets.alert msg
  end
  
  def start
    onstart
  end
  
end
