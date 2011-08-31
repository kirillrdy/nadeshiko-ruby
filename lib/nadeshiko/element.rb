module Nadeshiko

  # Base class for everything in Nadeshiko
  class Element

    attr_accessor :app
    attr_accessor :parent_id, :id,:element_type

    include Dsl
    include Jquery

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

      @app.register_element self
    end


    # generates random id 
    def generate_random_id
      Digest::SHA1.hexdigest(rand.to_s)[0..6]
    end

    def add_element element
      element.parent_id = self.id
      element.add_own_element_to_parent
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
