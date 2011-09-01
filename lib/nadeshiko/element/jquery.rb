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

  #  def onkeypress &block
  #    @app.dom_on_sockets.add_onkeypress @id,&block
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
