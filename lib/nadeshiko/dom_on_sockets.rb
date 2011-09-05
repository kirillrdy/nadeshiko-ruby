class Nadeshiko::DomOnSockets
  attr_accessor :_batch_commands,:callbacks, :web_socket

  def initialize web_socket

    @web_socket = web_socket
    @web_socket.onopen do
      self.onopen
    end

    @web_socket.onclose do
      puts "Connection closed #{@web_socket.object_id}"
    end

    @web_socket.onmessage do |msg|
      self.onmessage msg
    end

    @callbacks = {}

    @_batch_commands = []
    @commands = ''
  end

  def execute cmd
    @commands += cmd
    @commands += "\n"

    if @_batch_commands == []
      puts "#{@web_socket.object_id} sending #{@commands.inspect}"
      @web_socket.send @commands
      @commands = ''
    end

  end

  def add_callback_block action, id, options = {} , &block
    if options[:once] == true
      _add_callback_block action,id do |*args|
        block.call *args
        clear_callbacks action,id
      end
    else
      _add_callback_block action,id,&block
    end
    
  end

  def _add_callback_block action,id,&block
    @callbacks[action] ||= {}
    @callbacks[action][id] ||= []
    @callbacks[action][id] << block
  end


  def clear_callbacks action,id
    @callbacks[action] ||= {}
    @callbacks[action][id] = []
  end

  def onmessage message
    puts "#{@web_socket.object_id} Recieved message: '#{message}'"
    action,id, *args = JSON.parse message
    #action,id, *args = message.split ',',-1

    @callbacks[action.to_sym][id].each{|x|
      x.call *args
    }

  end

end
