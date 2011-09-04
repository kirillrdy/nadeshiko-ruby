module Nadeshiko

  class Application < Element

    attr_accessor :dom_on_sockets,:app

    def initialize dom_on_sockets
      @dom_on_sockets = dom_on_sockets
      @elements = {}
      @app = self

      super({:app => self})

      @_nodes_stack << self
      @_append_method << :append

      @id = nil

      # Add self ( in this case to body )
      #add self
    end

    def style options = {}, &block
      values = block.call
      string = "<style type=\"text/css\" media=\"screen\">\n"
      
      values.each_pair do |selector,styles|
        string += "#{selector} {\n"
        styles.each_pair do |attribute,value|
          string += "#{attribute}: #{value};\n"
        end
        string += "}\n"
      end
      string += '</style>'
      append string
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

    # Get element by id
    # eg get_element :main_div
    def get_element id
      @elements[id.to_s]
    end

    def register_element element
      @elements[element.id.to_s] = element
    end

    def append_to element_id, &block
      @_nodes_stack << get_element(element_id)
      @_append_method << :append
      block.call
      @_nodes_stack.pop
      @_nodes_stack.pop
    end

    def prepend_to element_id, &block
      @_nodes_stack << get_element(element_id)
      @_append_method << :prepend
      block.call
      @_nodes_stack.pop
      @_append_method.pop
    end

  end

end
