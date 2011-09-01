class Nadeshiko::DomOnSockets
  attr_accessor :_batch_request,:message_list,:callbacks

  def initialize web_socket

    @web_socket = web_socket
    @web_socket.onopen do
      self.onopen
    end

    @web_socket.onclose do
      puts "Connection closed"
    end

    @web_socket.onmessage do |msg|
      self.onmessage msg
    end

    @callbacks = {}

    @_batch_commands = []
    @commands = ''
  end

  def _execute
    # if are in batch block
    return if @_batch_commands != []

    send @message_list
    @message_list = []
  end

  def execute cmd
    puts "#{@web_socket.object_id} sending #{cmd.inspect}"
    @web_socket.send cmd
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
    puts "clearing callbacls for #{action} #{id}"
    @callbacks[action] ||= {}
    @callbacks[action][id] = []
  end

  def onmessage message
    puts "#{@web_socket.object_id} Recieved message: '#{message}'"
    action,id, *args = message.split ',',-1

    @callbacks[action.to_sym][id].each{|x|
      puts "calling #{action} #{id} callback"
      x.call *args
    }

#    action,selector,arg1 = cmds
#    id = selector.delete '#'

#    case action
#      when 'click'
#        callbacks_block = @onclick[id]
#        callbacks_block.call
#      when 'keypress'
#        @onkeypress[id].call arg1
#      when 'value'
#        @get_value[id].call arg1
#      when 'screen_size'
#        @get_screen_size.call selector,arg1
#      when 'sortable_update'
#        #TODO fix
#        @sortable.call id, arg1
#    end

  end

  def add
  end

#  def add_element element_type,id,parent_id
#    hash = {
#      'method' => 'add_element',
#      'element_type' => element_type,
#      'id' => id,
#      'selector' => '#'+parent_id
#    }
#    send hash
#  end

#  def append element_type,id,parent_id
#    hash = {
#      'method' => 'append',
#      'content' => "<#{element_type} id=\"#{id}\"></#{element_type}>",
#      'selector' => '#'+parent_id
#    }
#    send hash
#  end

#  def append_style_to_body style
#    hash = {
#      'method' => 'append',
#      'content' => "<style type=\"text/css\" media=\"screen\">#{style}</style>",
#      'selector' => 'body'
#    }
#    send hash
#  end

#  def prepend element_type,id,parent_id
#    hash = {
#      'method' => 'prepend',
#      'content' => "<#{element_type} id=\"#{id}\"></#{element_type}>",
#      'selector' => '#'+parent_id
#    }
#    send hash
#  end

#  def add_element_to_body element_type,id
#    hash = {
#      'method' => 'add_element',
#      'element_type' => element_type,
#      'id' => id,
#      'selector' => 'body'
#    }
#    send hash
#  end

#  def set_inner_html id, text
#    hash = {
#      'method' => 'set_inner_html',
#      'selector' => '#'+id,
#      'text' => text
#    }
#    send hash
#  end

#  def alert message
#    hash = {
#      'method' => 'alert',
#      'message' => message
#    }
#    send hash
#  end


#  def get_value id, &block
#    hash = {
#      'method' => 'get_value',
#      'selector' => '#'+id
#    }
#    send hash
#    @get_value[id] = block
#  end

#  def get_screen_size &block
#    hash = {
#      'method' => 'get_screen_size'
#    }
#    send hash
#    @get_screen_size = block
#  end

#  def sortable id,&block
#    hash = {
#      'method' => 'sortable',
#      'selector' => '#'+id
#    }
#    send hash
#    @sortable = block
#  end

#  def add_onclick id, &block
#    hash = {
#      'method' => 'add_onclick',
#      'selector' => '#'+id
#    }
#    send hash
#    @onclick[id] = block

#  end

#  def add_onkeypress id, &block
#    hash = {
#      'method' => 'add_onkeypress',
#      'selector' => '#'+id
#    }
#    send hash
#    @onkeypress[id] = block

#  end

#  def set_value id, value
#    hash = {
#      'method' => 'set_value',
#      'selector' => '#'+id,
#      'value' => value
#    }
#    send hash
#  end

#  def make_draggable id, handle_id
#    hash = {
#      'method' => 'make_draggable',
#      'selector' => '#'+id,
#      'handle_selector' => '#'+handle_id.to_s
#    }
#    send hash
#  end

#  def remove_element id
#    hash = {
#      'method' => 'remove_element',
#      'selector' => '#'+id,
#    }
#    send hash
#  end

#  def set_css_by_selector  selector, property, value
#    hash = {
#      'method' => 'set_css',
#      'selector' => selector,
#      'property' => property,
#      'value' => value
#    }
#    send hash
#  end

#  def show_element id
#    hash = {
#      'method' => 'show_element',
#      'selector' => '#'+ id
#    }
#    send hash
#  end

#  def set_css id, property,value
#    hash = {
#      'method' => 'set_css',
#      'selector' => '#'+id,
#      'property' => property,
#      'value' => value
#    }
#    send hash
#  end

#  def empty id
#    hash = {
#      'method' => 'empty',
#      'selector' => '#'+id
#    }
#    send hash
#  end

#  def insert_after id,target_id
#    hash = {
#      'method' => 'insert_after',
#      'selector' => '#'+id,
#      'target' => '#'+target_id
#    }
#    send hash
#  end

# def add_class id,value
#    hash = {
#      'method' => 'add_class',
#      'selector' => '#'+id,
#      'value' => value
#    }
#    send hash
#  end
end
