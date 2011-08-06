class MyApp < App

  def setup_app
    main = Element.new
    main.element_id = 'main'

    @list = List.new
    main.add @list

    @textfield = Textfield.new
    main.add @textfield

    @textfield.onkeypress do |keypressed|
      on_add_button_click if keypressed.to_i == 13
    end

    @button = Button.new 'Add New Entry' do
      on_add_button_click
    end
    main.add @button

  end

  def on_add_button_click
    @textfield.get_value do |value|
      @list.add_item value
      @textfield.set_value ''
    end
  end

end
