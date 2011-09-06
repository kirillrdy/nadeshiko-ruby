module Nadeshiko

  # Base class for everything in Nadeshiko
  class Element

    attr_accessor :app
    attr_accessor :parent_id, :id,:element_type,:options

    include Dsl
    include Jquery
    include JqueryUi

    def initialize(options = {})
      @_nodes_stack = [self]
      @_append_method = [:append]

      default_options = {
        :app => options[:app],
        :id => generate_random_id,
        :element_type => 'div'
      }

      @options =  default_options.merge options

      @app =  @options[:app]
      @id = @options[:id].to_s

      @element_type = options[:element_type]

      @app.register_element self
    end


    # generates random id 
    def generate_random_id
      Digest::SHA1.hexdigest(rand.to_s)[0..6]
    end

    def get_element element_id
      @app.get_element element_id
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
      @app.dom_on_sockets._batch_commands << nil
      block.call
      @app.dom_on_sockets._batch_commands.pop

      # just need to call this function
      @app.dom_on_sockets.execute ''
    end

    # When parent add child, it calls 'setup' on it
    def setup
      text @options[:text] if @options[:text]

      add_class @options[:class] if @options[:class]

      #TODO add handling for style attribute

    end

  end

end
