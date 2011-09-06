module Nadeshiko
  module Dsl
    #TODO add meta programming magic,
    # i dont like method missing
    def method_missing element_type,*args, &block

      options = args.first || {}
      options.merge!({:app => app, :element_type => element_type})

      html_based_elements = [:h1,:h2,:h3,:h4,:div,:input,:button,
        :table,:tr,:th,:td,:thead,:tbody,:span,
        :ul,:li,:link]

      if html_based_elements.include? element_type
        new_element = Element.new options
      else
        begin
          const_sym = element_type.capitalize.to_sym
          element_class = Nadeshiko.const_get const_sym
          new_element = element_class.new options
        rescue NameError => e
          super
        end
      end

      @_nodes_stack.last.send @_append_method.last, new_element

      new_element.setup

      if block_given?
        @_nodes_stack << new_element
        @_append_method << :append
        block.call
        @_nodes_stack.pop
        @_append_method.pop
      end

      # return newly created element
      # so that in dsl you can get ref to it
      return new_element
    end
  end
end
