class DomOnSockets

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

    @get_value = {}
    @onclick = {}
    @onkeypress = {}
  end


  def send message
    puts message
    @web_socket.send message
  end


  def onmessage message
    puts "Recieved message: '#{message}'"
    cmds = message.split ',',-1
    
    action,selector,arg1 = cmds
    id = selector.delete '#'

    case action
      when 'click'
        callbacks_block = @onclick[id]
        callbacks_block.call
      when 'keypress'
        @onkeypress[id].call arg1
      when 'value'
        @get_value[id].call arg1
    end

  end

  def add_element element_type,id,parent_id
    hash = {
      'method' => 'add_element',
      'element_type' => element_type,
      'id' => id,
      'selector' => '#'+parent_id
    }
    send hash.to_json
  end

  def add_element_to_body element_type,id
    hash = {
      'method' => 'add_element',
      'element_type' => element_type,
      'id' => id,
      'selector' => 'body'
    }
    send hash.to_json
  end

  def set_inner_html id, text
    hash = {
      'method' => 'set_inner_html',
      'selector' => '#'+id,
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
      'selector' => '#'+id
    }
    send hash.to_json
    @get_value[id] = block
  end


  def add_onclick id, &block
    hash = {
      'method' => 'add_onclick',
      'selector' => '#'+id
    }
    send hash.to_json
    @onclick[id] = block

  end

  def add_onkeypress id, &block
    hash = {
      'method' => 'add_onkeypress',
      'selector' => '#'+id
    }
    send hash.to_json
    @onkeypress[id] = block

  end

  def set_value id, value
    hash = {
      'method' => 'set_value',
      'selector' => '#'+id,
      'value' => value
    }
    send hash.to_json
  end

  def remove_element id
    hash = {
      'method' => 'remove_element',
      'selector' => '#'+id,
    }
    send hash.to_json
  end

  def set_css_by_selector  selector, property, value
    hash = {
      'method' => 'set_css',
      'selector' => selector,
      'property' => property,
      'value' => value
    }
    send hash.to_json
  end

  def set_css id, property,value
    hash = {
      'method' => 'set_css',
      'selector' => '#'+id,
      'property' => property,
      'value' => value
    }
    send hash.to_json
  end

end
