module Nadeshiko::JqueryUi

  # Should take a block of events
  def sortable options={}
    string =<<-EOL
      $('##{@id}').sortable(#{options.to_json})
    EOL
    @app.dom_on_sockets.execute string
  end

  def draggable
    string = "$('##{@id}').draggable()"
    @app.dom_on_sockets.execute string
  end

  def sortupdate &block
    @app.dom_on_sockets.add_callback_block :sortupdate,@id, &block
    string =<<-EOL
      $('##{@id}').bind('sortupdate',function(event,ui){
        var array = ['sortupdate','#{@id}',ui.item.attr("id")]
        ws.send(JSON.stringify(array))
      })
    EOL
    @app.dom_on_sockets.execute string
  end


  #OLD effects
#  def effect args = ''
#    _call_method_with_params :effect, args
#  end

  def effect effect,options = {}, speed = 1000
    selector = @id == nil ? 'body' : "##{@id}"
    string = "$('#{selector}').effect(#{effect.inspect},{},#{speed})"
    @app.dom_on_sockets.execute string
  end

end
