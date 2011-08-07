class MyApp < App

  def setup_app
    main = Element.new self
    main.element_id = 'main'

    @list = List.new self
    main.add_element @list

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
      @list.add_item value if value != ''
      @textfield.set_value ''
    end
  end

end
