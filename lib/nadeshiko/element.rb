module Nadeshiko

  # Base class for everything in Nadeshiko
  class Element

    attr_accessor :app
    attr_accessor :parent_id, :id,:element_type

    def initialize(options = {})
      @_nodes_stack = [self]

      default_options = {
        :app => options[:app],
        :id => generate_random_id,
        :element_type => 'div'
      }

      options =  default_options.merge options

      @app =  options[:app]
      @id = options[:id].to_s
      @element_type = options[:element_type]
      @text = options[:text]
      @style = options[:style]

      @options = options

      register_element_with_app self
    end

    #TODO refactor
    def register_element_with_app element
      @app.register_element element
    end

    #TODO add meta programming magic,
    # i dont like method missing
    def method_missing element_type,*args, &block

      html_based_elements = [:h1,:div,:input,:button,:table,:tr,:th,:td,:thead,:tbody,:h4,:span]
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

      @_nodes_stack.last.add_element new_element

      #self.add_element a

      if block_given?
        @_nodes_stack << new_element
        block.call
        @_nodes_stack.pop
      end

      # return newly created element
      return new_element
    end

    # generates random id 
    def generate_random_id
      Digest::SHA1.hexdigest(rand.to_s)[0..6]
    end

    def add_element element
      element.parent_id = self.id
      element.add_own_element_to_parent
    end

#    def add_elements &block
#      self.instance_eval &block
#    end

    # Shows hidden elements
    # has no effect if element already visible
    def show_element
      @app.dom_on_sockets.show_element @id
    end

    # Empties content of the element
    def empty
      @app.dom_on_sockets.empty @id
    end

    def add_class class_name
      @app.dom_on_sockets.add_class @id,class_name
    end

    # Adds self to parent
    # if parent is nil adds self to body
    def add_own_element_to_parent
      if parent_id == nil || parent_id.empty?
        @app.dom_on_sockets.add_element_to_body @element_type,@id
      else
        @app.dom_on_sockets.add_element @element_type,@id,@parent_id
      end
      setup
    end


    # Will batch all messages
    #
    #   batch_messages do
    #     do_something
    #     # no message are sent
    #   end
    #   #messages get sent here
    #
    def batch_messages &block
      @app.dom_on_sockets._batch_request << nil
      block.call
      @app.dom_on_sockets._batch_request.pop
      @app.dom_on_sockets.flush_message_list
    end

  #  #TODO finish
  #  # Appends self to either known parent or body
  #  def append_self # assumes it knows parent, or appends to body
  #  end

  #  #TODO
  #  # appends to self
  #  def append content
  #  end
  #  
  #  # append self to parent
  #  def append_to parent_id
  #  end

  #  #TODO prepend finish
  #  # Make same methods as above for prepending
  #  def prepend_self
  #  end

    # Removes element from DOM
    def remove_element
      @app.dom_on_sockets.remove_element @id
    end

    # sets inner text for element
    # TODO rename to set_html or html to be consitent with JQuery
    def set_inner_html text
      @app.dom_on_sockets.set_inner_html @id, text
    end

    def set_css property,value
      @app.dom_on_sockets.set_css @id,property,value
    end

    def onclick &block
      @app.dom_on_sockets.add_onclick @id,&block
    end

    def onkeypress &block
      @app.dom_on_sockets.add_onkeypress @id,&block
    end

    def get_value &block
      @app.dom_on_sockets.get_value @id, &block
    end

    def set_value value
      @app.dom_on_sockets.set_value @id, value
    end

    def make_draggable handle_id
      @app.dom_on_sockets.make_draggable @id,handle_id
    end


    # When parent add child, it calls 'setup' on it
    def setup
      # Set inner_html as @text
      set_inner_html @text if @text

      # Apply Styles
      if @style
        @style.each_pair do |k,v|
          set_css k,v
        end
      end

      if @options[:class]
        if @options[:class].is_a? String
          add_class @options[:class]
        end
        if @options[:class].is_a? Array
          @options[:class].each{|x| add_class x }
        end
      end

    end

  end

end
