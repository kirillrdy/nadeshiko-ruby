module Nadeshiko
  module Jquery

    # Appends Element or string
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

    # Prepends Element or string
    def prepend object
      case object
        when String
          _prepend_string object
        when Element
          _prepend_element object
        else
          raise "Can not add non supported object"
      end
    end

    def after object
      case object
        when String
          _after_string object
        when Element
          _after_element object
        else
          raise "Can not add non supported object"
      end
    end

    def insert_after object
      _call_method_with_params :insertAfter, "##{object.id}"
    end

    def insert_before object
      _call_method_with_params :insertBefore, "##{object.id}"
    end

    # Sets inner html value of an element
    def text val
      string =<<-EOL
        $('##{@id}').text(#{val.inspect})
      EOL
      @app.dom_on_sockets.execute string
    end

    # Adds onclick callback
    def click &block
      @app.dom_on_sockets.add_callback_block :click,@id, &block
      string =<<-EOL
        $('##{@id}').click(function(){
          var array = ['click','#{@id}']
          ws.send(JSON.stringify(array))
        })
      EOL
      @app.dom_on_sockets.execute string
    end

    # adds onkeydown callback
    def keydown &block
      @app.dom_on_sockets.add_callback_block :keydown,@id, &block
      string =<<-EOL
        $('##{@id}').keydown(function(event){
          var array = ['keydown','#{@id}',event.which]
          ws.send(JSON.stringify(array))
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

    # Empties elements content
    def empty
      string="$('##{@id}').empty()"
      @app.dom_on_sockets.execute string
    end

    # Removes element
    def remove
      string="$('##{@id}').remove()"
      @app.dom_on_sockets.execute string
    end

    # Add handling for getting value of attribute,
    # currently only sets attribute values
    def attr attribute_name,value = nil
      string="$('##{@id}').attr('#{attribute_name}','#{value}')"
      @app.dom_on_sockets.execute string
    end

    # Adds class to an element
    def add_class class_name
      string="$('##{@id}').addClass(#{class_name.to_s.inspect})"
      @app.dom_on_sockets.execute string
    end

    # Removes class from an element
    def remove_class class_name
      string="$('##{@id}').removeClass(#{class_name.to_s.inspect})"
      @app.dom_on_sockets.execute string
    end

    # Bind to custom event
    def bind event, &block
      @app.dom_on_sockets.add_callback_block event, @id, &block
      string =<<-EOL
        $('##{@id}').bind(#{event.inspect}, function(event,ui){
          ws.send('#{event.inspect},#{@id}')
        })
      EOL
      @app.dom_on_sockets.execute string
    end

    def index &block
      _get_return_value_of_method_call :index, &block
    end

    def next &block
      _get_return_value_of_method_call :next, '.attr("id")' , &block
    end

    def prev &block
      _get_return_value_of_method_call :prev, '.attr("id")' , &block
    end

    def trigger event_name
      @app.dom_on_sockets.execute "$('##{@id}').trigger('#{event_name}')"
    end

    #TODO move this elsewhere, doesnt belong to jquery
    def to_html
      child_type = element_type
      type_string = ''
      type_string = "type=\"#{@type}\"" if @type

      element_string = "<#{child_type} id=\"#{@id}\" #{type_string}></#{child_type}>"
    end


  private

    def _get_val &block
      _get_return_value_of_method_call :val, &block
    end

    def _set_val val
      string =<<-EOL
        $('##{@id}').val('#{val}')
      EOL
      @app.dom_on_sockets.execute string
    end

    def _get_return_value_of_method_call method, additional_params = '' , &block
      @app.dom_on_sockets.add_callback_block method, @id, :once => true, &block

      string =<<-EOL
        var a = $('##{@id}').#{method}()#{additional_params}
        var array = ['#{method}','#{@id}',a]
        ws.send(JSON.stringify(array))
      EOL
      @app.dom_on_sockets.execute string
    end


    def _append_element element
      _append_string element.to_html
    end

    def _append_string string_to_append
      _call_method_with_params :append, string_to_append
    end

    def _prepend_element element
      _prepend_string element.to_html
    end

    def _prepend_string string_to_prepend
      _call_method_with_params :prepend, string_to_prepend
    end

    def _after_element element
      _after_string element.to_html
    end

    def _after_string string_to_add
      _call_method_with_params :after, string_to_add
    end

    def _call_method_with_params method,argument
      selector = @id == nil ? 'body' : "##{@id}"
      string = "$('#{selector}').#{method}(#{argument.inspect})"
      @app.dom_on_sockets.execute string
    end

  end
end
