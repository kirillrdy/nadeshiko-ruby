module Nadeshiko

  class Application < Element

    attr_accessor :dom_on_sockets,:app

    def initialize dom_on_sockets
      @dom_on_sockets = dom_on_sockets
      @elements = {}
      @app = self

      super({:app => self})
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


    def add_elements_to element_id, &block
      @_nodes_stack << get_element(element_id)
      self.instance_eval &block
      @_nodes_stack.pop
    end

  end

end
