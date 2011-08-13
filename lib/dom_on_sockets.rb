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

  def add_element element_type,element_id,parent_id
    hash = {
      'method' => 'add_element',
      'element_type' => element_type,
      'element_id' => element_id,
      'parent_id' => parent_id
    }
    send hash.to_json
  end

  def add_element_to_body element_type,element_id
    hash = {
      'method' => 'add_element_to_body',
      'element_type' => element_type,
      'element_id' => element_id,
    }
    send hash.to_json
  end

  def set_inner_html element_id, text
    hash = {
      'method' => 'set_inner_html',
      'element_id' => element_id,
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


  def get_value element_id, &block
    hash = {
      'method' => 'get_value',
      'element_id' => element_id
    }
    send hash.to_json
    @get_value ||= {}
    @get_value[element_id] = block
  end


  def add_onclick element_id, &block
    hash = {
      'method' => 'add_onclick',
      'element_id' => element_id
    }
    send hash.to_json

    @onclick ||= {}
    @onclick[element_id] = block

  end

  def add_onkeypress element_id, &block
    hash = {
      'method' => 'add_onkeypress',
      'element_id' => element_id
    }
    send hash.to_json

    @onkeypress ||= {}
    @onkeypress[element_id] = block

  end

  def set_value element_id, value
    hash = {
      'method' => 'set_value',
      'element_id' => element_id,
      'value' => value
    }
    send hash.to_json
  end

  def remove_element element_id
    hash = {
      'method' => 'remove_element',
      'element_id' => element_id,
    }
    send hash.to_json
  end

  def set_css element_id, property,value
    hash = {
      'method' => 'set_css',
      'element_id' => element_id,
      'property' => property,
      'value' => value
    }
    send hash.to_json
  end

end
