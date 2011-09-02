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

    #TODO move this elsewhere, doesnt belong to jquery
    def to_html
      child_type = element_type
      element_string = "<#{child_type} id=\"#{@id}\"></#{child_type}>"
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
        ws.send('#{method},#{@id},'+ a )
      EOL
      @app.dom_on_sockets.execute string
    end


    def _append_element element
      _append_string element.to_html
    end

    def _append_string string_to_append
      _call_method_with_params :append, string_to_append
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
