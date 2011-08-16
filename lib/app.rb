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
    #@dom_on_sockets.send_at_once = false
    root = Node.new nil
    root.instance_eval &block

    root.children.each do |child|
      parse_nodes child
    end
    #@dom_on_sockets.flush_message_list
  end

  def parse_nodes root, parent = nil

    options = {:app => self}

    if root.args && root.args.first && root.args.first.is_a?(Hash)
      options.merge! root.args.first
    end

    case root.element_type
      when :grid
        e = Grid.new options
      when :dialog
        e = Dialog.new options
        
      else
        e = Element.new options.merge({:element_type => root.element_type})
    end


    register_element e

    if parent == nil
      e.add_own_element_to_body
    else
      parent.add_element e
    end

    root.children.each do |x|
      parse_nodes x, e
    end
  end

  def register_element element
    @elements[element.id] = element
  end

  def get_element id
    @elements[id.to_s]
  end

end
