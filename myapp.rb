class MyApp < App

  def onstart

    add_elements do
      div :id => :main, :style => { :margin => :auto, :border => '1px solid black',  :width => '1000px',
                'background-color' => '#eee', 'border-radius'=> '5px' } do
        div :height => '80px','border-radius'=> '5px', :padding => '5px', 'margin-top' => '5px' do
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

#    grid.set_css 'height','500px'
#    grid.set_css 'width','300px'
#    grid.set_css 'overflow','auto'
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
