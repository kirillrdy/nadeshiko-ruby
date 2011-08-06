class App

  def initialize ws
    @dom_on_sockets = DomOnSockets.new(ws)
    ws.onopen do
      setup_app
    end
  end

  def setup_app
    @dom_on_sockets.add_element 'div','div1','main'
    @dom_on_sockets.set_inner_html 'div1','Hello'
    @dom_on_sockets.set_css 'div1','border','1px solid black'
    @dom_on_sockets.set_css 'div1','width','200px'

    @dom_on_sockets.add_onclick 'div1' do
      @dom_on_sockets.alert 'hello'
    end

  end
end
