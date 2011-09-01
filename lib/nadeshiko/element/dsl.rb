module Nadeshiko
  module Dsl
    #TODO add meta programming magic,
    # i dont like method missing
    def method_missing element_type,*args, &block

      html_based_elements = [:h1,:div,:input,:button,
        :table,:tr,:th,:td,:thead,:tbody,:h4,:span,
        :ul,:li]
      magic_based_elements = [:grid2]

      super unless (html_based_elements + magic_based_elements).include? element_type

      options = args.first || {}

      options.merge!({:app => app, :element_type => element_type})

      case element_type
        when :grid2
          new_element = Grid2.new(options)
        else
          new_element = Element.new(options)
      end

      @_nodes_stack.last.append new_element
      new_element.setup

      if block_given?
        @_nodes_stack << new_element
        block.call
        @_nodes_stack.pop
      end

      # return newly created element
      # that in dsl you can get ref to it
      return new_element
    end
  end
end
