module Nadeshiko
 module Jquery

  def append object
    case object
      when String
        _append_string object
      when Element
        _append_element object
      else
        raise "Can not add non supported object"
    end
  end

  def _append_element element
    child_type = element.element_type
    element_string = "<#{child_type} id=\"#{element.id}\"></#{child_type}>"
    _append_string element_string
  end

  def _append_string string_to_append
    selector = @id == nil ? 'body' : "##{@id}"

    string = "$('#{selector}').append(#{string_to_append.inspect})"
    @app.dom_on_sockets.execute string
  end



  def text val
    string =<<-EOL
      $('##{@id}').text('#{val}')
    EOL
    @app.dom_on_sockets.execute string
  end

  def click &block
    @app.dom_on_sockets.add_callback_block :click,@id, &block
    string =<<-EOL
      $('##{@id}').click(function(){
        ws.send('click,#{@id}')
      })
    EOL
    @app.dom_on_sockets.execute string
  end

  # Gets or sets value of element
  def val value=nil, &block
    if value
      _set_val value
    end
    if block_given?
      _get_val &block
    end
  end

  def empty
    string="$('##{@id}').empty()"
    @app.dom_on_sockets.execute string
  end

  def remove
    string="$('##{@id}').remove()"
    @app.dom_on_sockets.execute string
  end

  def add_class class_name
    string="$('##{@id}').addClass(#{class_name.to_s.inspect})"
    @app.dom_on_sockets.execute string
  end


  # Shows hidden elements
  # has no effect if element already visible
#  def show
#    @app.dom_on_sockets.show_element @id
#  end

#  # Empties content of the element
#  def empty
#    @app.dom_on_sockets.empty @id
#  end

#  def add_class class_name
#    @app.dom_on_sockets.add_class @id,class_name
#  end

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
#  def remove_element
#    @app.dom_on_sockets.remove_element @id
#  end

  # sets inner text for element
  # TODO rename to set_html or html to be consitent with JQuery
#  def set_inner_html text
#    @app.dom_on_sockets.set_inner_html @id, text
#  end

#  def set_css property,value
#    @app.dom_on_sockets.set_css @id,property,value
#  end

#  def onclick &block
#    @app.dom_on_sockets.add_onclick @id,&block
#  end

#  def onkeypress &block
#    @app.dom_on_sockets.add_onkeypress @id,&block
#  end

#  def get_value &block
#    @app.dom_on_sockets.get_value @id, &block
#  end

#  def set_value value
#    @app.dom_on_sockets.set_value @id, value
#  end

#  def make_draggable handle_id
#    @app.dom_on_sockets.make_draggable @id,handle_id
#  end


#  def insert_after element
#    @app.dom_on_sockets.insert_after @id,element.id
#  end

private

  def _get_val &block
    @app.dom_on_sockets.add_callback_block :val, @id, :once => true, &block

    string =<<-EOL
      var a = $('##{@id}').val()
      ws.send('val,#{@id},'+ a )
    EOL
    @app.dom_on_sockets.execute string
  end

  def _set_val val
    string =<<-EOL
      $('##{@id}').val('#{val}')
    EOL
    @app.dom_on_sockets.execute string
  end

  end
end
