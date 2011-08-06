class DomOnSockets

  def initialize ws
    @ws = ws
    @ws.onopen do
      self.onopen
    end
    
    @ws.onclose do
      self.onclose
    end
    
    @ws.onmessage do |msg|
      self.onmessage msg
    end

  end

  def send message
    @ws.send message
  end

#  def onopen
#    setup_app
#  end

  def onclose
    puts "Connection closed"
  end

  def onmessage message
    puts "Recieved message: #{message}"
    cmds = message.split ','
    if cmds.first == 'click'
      @onclick[cmds.last].call
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

  def add_onclick element_id, &block
    hash = {
      'method' => 'add_onclick',
      'element_id' => element_id
    }
    send hash.to_json

    @onclick ||= {}
    @onclick[element_id] = block

  end


  def set_css element_id, property,value
    hash = {
      'element_id' => element_id,
      'method' => 'set_css',
      'property' => property,
      'value' => value
    }
    send hash.to_json
  end

end
