class Element

  attr_accessor :parent_id, :element_id,:element_type

  def initialize
    @element_id = Digest::SHA1.hexdigest(rand.to_s)[0..5]
    @element_type = 'div'
  end

  def add element
    element.parent_id = self.element_id
    element.add_own_element_to_parent
    element.setup
  end

  def add_own_element_to_parent
    App.dom_on_sockets.add_element @element_type,@element_id,@parent_id
  end

  def set_inner_html text
    App.dom_on_sockets.set_inner_html @element_id, text
  end

  def set_css property,value
    App.dom_on_sockets.set_css @element_id,property,value
  end

  def onclick &block
    App.dom_on_sockets.add_onclick @element_id,&block
  end

  def onkeypress &block
    App.dom_on_sockets.add_onkeypress @element_id,&block
  end

  def alert message
    App.dom_on_sockets.alert message
  end

  def get_value &block
    App.dom_on_sockets.get_value @element_id, &block
  end

  def set_value value
    App.dom_on_sockets.set_value @element_id, value
  end

  def setup
    set_inner_html 'Basic Element'
    set_css 'border','1px solid black'
    set_css 'width','200px'

#    onclick do
#      alert 'Hello from Kirill'
#    end
  end

end
