class MyApp < App

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

    @list = Grid.new self, MovieStore
    main.add_element @list

    # load data from store
    @list.load

    @textfield = Textfield.new self
    main.add_element @textfield

    @textfield.onkeypress do |keypressed|
      on_add_button_click if keypressed.to_i == 13
    end

    @button = Button.new self,'Add New Entry' do
      on_add_button_click
    end
    main.add_element @button

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
