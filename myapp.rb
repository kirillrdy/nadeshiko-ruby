class MyApp < App

  def setup_app

    add_elements do
      div :id => :main, :style => { :margin => :auto, :width => '300px' } do
        div :height => '30px' do
          h1 :text => 'Eiga'
        end
        input :id => :textfield
        button :id => :add_new_record, :text => 'Add New Entry'
        grid  :id => :movies_grid,
              :store => MovieStore,
              :columns => [:id, :title]
      end
    end

    button = get_element :add_new_record
    textfield = get_element :textfield
    grid = get_element :movies_grid

    grid.load

    button.onclick do
      on_add_button_click
    end

    textfield.onkeypress do |key|
      on_add_button_click if key.to_i == 13
    end

#    e.set_css 'height','500px'
#    e.set_css 'overflow','auto'
#    e.set_css 'width','300px'
#    e.set_css 'border','1px solid black'

  end

  def on_add_button_click
    textfield = get_element :textfield
    textfield.get_value do |value|
      if value != ''
        MovieStore.add :title => value
      else
        alert 'Please enter something'
      end
      textfield.set_value ''
    end
  end

end
