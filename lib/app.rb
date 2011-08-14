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
    onstart
  end

  def add_elements &block
    root = Node.new :div
    root.instance_eval &block

    puts root.inspect
    root.children.each do |child|
      parse_nodes child
    end
  end

  def parse_nodes root, parent = nil

    options = {:app => self}

    if root.args && root.args.first && root.args.first.is_a?(Hash)
      options.merge! root.args.first
    end

    case root.element_type
      when :grid
        e = Grid.new options
      else
        e = Element.new options.merge({:element_type => root.element_type})
    end

    @elements[e.id] = e

    if parent == nil
      e.add_own_element_to_body
      e.setup
    else
      parent.add_element e
    end

    root.children.each do |x|
      parse_nodes x, e
    end
  end

  def get_element id
    @elements[id.to_s]
  end

end
