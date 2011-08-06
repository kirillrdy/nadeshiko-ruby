class App

  class << self
    attr_accessor :dom_on_sockets
  end

  def initialize ws
    App.dom_on_sockets = DomOnSockets.new(ws)
    ws.onopen do
      setup_app
    end
  end

  def setup_app
    main = Element.new
    main.element_id = 'main'

    list = List.new
    main.add list

    textfield = Textfield.new
    main.add textfield

    button = Button.new 'Add New Entry' do
      textfield.get_value do |value|
        list.add_item value
      end
    end
    main.add button

  end
end


class Element

  attr_accessor :parent_id, :element_id,:element_type

  def initialize
    @element_id = Digest::SHA1.hexdigest(rand.to_s)
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

  def alert message
    App.dom_on_sockets.alert message
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

class Button < Element
  def initialize title, &block
    super()
    @element_type = 'button'
    @title = title
    @onclick = block
  end

  def setup
    set_inner_html @title
    onclick &@onclick
  end

end

class Textfield < Element
  def initialize
    super()
    @element_type = 'input'
  end
  
  def get_value &block
    
    App.dom_on_sockets.get_value @element_id, &block
  end
  
end


class List < Element
  attr_accessor :items



  def add_item string
    item = Element.new
    add item

    item.set_inner_html string
    item.onclick do
      alert 'You clicked ' + string
    end
    @items ||=[]
    @items << item
  end

  def setup
#    add_item 'hello'
#    add_item 'hello2'
#    add_item 'hello3'
  end
end
