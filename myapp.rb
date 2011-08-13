class MyApp < App

  def onstart
    
  end

  def parse_nodes root, parent
    e = Element.new self
    e.element_type = root.element_type.to_s

    parent.add_element e

    root.children.each do |x|
      parse_nodes x, e
    end

  end

  def setup_app
    # div :main do
    #   grid :store => MovieStore
    #   textfield
    #   button 'Add new Entry' do
    #     get 'textfield1'
    #   end
    # end

    main = Element.new self
    main.element_id = 'main'

    root = Node.new :div
    root.instance_eval do
      div do
        button 'hello'
      end
    end

    parse_nodes root, main

    @textfield = Textfield.new self
    main.add_element @textfield

    @textfield.onkeypress do |keypressed|
      on_add_button_click if keypressed.to_i == 13
    end

    @button = Button.new self,'Add New Entry' do
      on_add_button_click
    end
    main.add_element @button

    e = Element.new self
    main.add_element e

    @list = Grid.new self, MovieStore, :columns => [:id,:title]
    e.add_element @list

    e.set_css 'height','500px'
    e.set_css 'overflow','auto'
    e.set_css 'width','300px'
    e.set_css 'border','1px solid black'
    # load data from store
    @list.load

  end

  def on_add_button_click
    @textfield.get_value do |value|
      if value != ''
        MovieStore.add :title => value
      else
        dom_on_sockets.alert 'Please enter something'
      end
      @textfield.set_value ''
    end
  end

end
