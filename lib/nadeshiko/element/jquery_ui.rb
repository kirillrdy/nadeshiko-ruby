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

end
