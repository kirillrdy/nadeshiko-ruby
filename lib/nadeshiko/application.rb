class Nadeshiko::Application

  attr_accessor :dom_on_sockets

  def initialize dom_on_sockets
    @dom_on_sockets = dom_on_sockets
    @elements = {}
  end

  # Client side alert
  def alert msg
    @dom_on_sockets.alert msg
  end
  
  def start
    batch_messages do
      onstart
    end
  end

  def batch_messages &block
    @dom_on_sockets._batch_request << nil
    block.call
    @dom_on_sockets._batch_request.pop
    @dom_on_sockets.flush_message_list
  end

  def add_elements &block
    root = Element.new({:app => self, :id => nil})
    root.instance_eval &block
  end

  # Get element by id
  # eg get_element :main_div
  def get_element id
    @elements[id.to_s]
  end

  def register_element element
    @elements[element.id.to_s] = element
  end

end
