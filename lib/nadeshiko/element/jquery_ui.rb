module Nadeshiko::JqueryUi

  # Should take a block of events
  def sortable
    string =<<-EOL
      $('##{@id}').sortable()
    EOL
    @app.dom_on_sockets.execute string
  end

end
