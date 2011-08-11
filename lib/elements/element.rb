class Element

  attr_accessor :app
  attr_accessor :parent_id, :element_id,:element_type

  include Dsl

  def initialize app
    @app = app
    @element_id = Digest::SHA1.hexdigest(rand.to_s)[0..6]
    @element_type = 'div'
  end

  def add_element element
    element.parent_id = self.element_id
    element.add_own_element_to_parent
    element.setup
  end

  def add_own_element_to_parent
    @app.dom_on_sockets.add_element @element_type,@element_id,@parent_id
  end

  def remove_own_element
    @app.dom_on_sockets.remove_element @element_id
  end

  def set_inner_html text
    @app.dom_on_sockets.set_inner_html @element_id, text
  end

  def set_css property,value
    @app.dom_on_sockets.set_css @element_id,property,value
  end

  def onclick &block
    @app.dom_on_sockets.add_onclick @element_id,&block
  end

  def onkeypress &block
    @app.dom_on_sockets.add_onkeypress @element_id,&block
  end

  def alert message
    @app.dom_on_sockets.alert message
  end

  def get_value &block
    @app.dom_on_sockets.get_value @element_id, &block
  end

  def set_value value
    @app.dom_on_sockets.set_value @element_id, value
  end

  def setup
    #set_inner_html 'Basic Element'
    set_css 'border','1px solid black'
    #set_css 'width','200px'

#    onclick do
#      alert 'Hello from Kirill'
#    end
  end

end
