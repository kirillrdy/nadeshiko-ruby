class MyApp < App

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
        textfield.set_value ''
      end
    end
    main.add button

  end

end
