class App
  attr_accessor :dom_on_sockets
  def initialize dom_on_sockets
    @dom_on_sockets = dom_on_sockets
    @elements = {}
  end
  
  def alert msg
    @dom_on_sockets.alert msg
  end
  
  def start
    @dom_on_sockets.send_at_once = false
    onstart
    @dom_on_sockets.flush_message_list
  end

  def batch_messages &block
    @dom_on_sockets.send_at_once = false
    block.call
    @dom_on_sockets.flush_message_list
  end

  def add_elements &block
    root = Element.new({:app => self, :id => nil})
    root.instance_eval &block
  end

  def register_element element
    @elements[element.id.to_s] = element
  end

  def get_element id
    @elements[id.to_s]
  end

end
