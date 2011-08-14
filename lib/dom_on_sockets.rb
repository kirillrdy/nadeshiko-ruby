class DomOnSockets

  def initialize web_socket

    # Lets setup our callbacks hash
    

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

  end


  def send message
    puts message
    @web_socket.send message
  end


  def onmessage message
    puts "Recieved message: '#{message}'"
    cmds = message.split ',',-1
    if cmds.first == 'click'
      callbacks_block = @onclick[cmds.last]
      callbacks_block.call
    end
    if cmds.first == 'keypress'
      @onkeypress[cmds[1]].call cmds.last
    end
    if cmds.first == 'value'
      @get_value[cmds[1]].call cmds.last
    end
  end

  def add_element element_type,id,parent_id
    hash = {
      'method' => 'add_element',
      'element_type' => element_type,
      'id' => id,
      'parent_id' => parent_id
    }
    send hash.to_json
  end

  def add_element_to_body element_type,id
    hash = {
      'method' => 'add_element_to_body',
      'element_type' => element_type,
      'id' => id,
    }
    send hash.to_json
  end

  def set_inner_html id, text
    hash = {
      'method' => 'set_inner_html',
      'id' => id,
      'text' => text
    }
    send hash.to_json
  end

  def alert message
    hash = {
      'method' => 'alert',
      'message' => message
    }
    send hash.to_json
  end


  def get_value id, &block
    hash = {
      'method' => 'get_value',
      'id' => id
    }
    send hash.to_json
    @get_value ||= {}
    @get_value[id] = block
  end


  def add_onclick id, &block
    hash = {
      'method' => 'add_onclick',
      'id' => id
    }
    send hash.to_json

    @onclick ||= {}
    @onclick[id] = block

  end

  def add_onkeypress id, &block
    hash = {
      'method' => 'add_onkeypress',
      'id' => id
    }
    send hash.to_json

    @onkeypress ||= {}
    @onkeypress[id] = block

  end

  def set_value id, value
    hash = {
      'method' => 'set_value',
      'id' => id,
      'value' => value
    }
    send hash.to_json
  end

  def remove_element id
    hash = {
      'method' => 'remove_element',
      'id' => id,
    }
    send hash.to_json
  end

  def set_css id, property,value
    hash = {
      'method' => 'set_css',
      'id' => id,
      'property' => property,
      'value' => value
    }
    send hash.to_json
  end

end
