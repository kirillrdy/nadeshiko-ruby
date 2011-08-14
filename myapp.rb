class MyApp < App

  def onstart

    #@dom_on_sockets.set_css_by_selector 'body','background-color','#333'
    @dom_on_sockets.set_css_by_selector 'body','padding','0px'
    @dom_on_sockets.set_css_by_selector 'body','margin','0px'

    main_style = { :margin => :auto, :border => '1px solid black',  :width => '1000px',
                'background-color' => '#eee', 'border-radius'=> '5px', 'margin-top' => '5px' }

    header_style = { :height => '80px','border-radius-top'=> '5px', :padding => '5px',
          #:background => '-moz-linear-gradient(top, #7abcff 0%,#60abf8 44%,#4096ee 100%)'
          :background => '-moz-linear-gradient(top, #1e5799 0%, #2989d8 50%, #207cca 51%, #7db9e8 100%)' }

    add_elements do
      div :id => :main, :style => main_style do
        div :style => header_style do
          h1 :text => 'Eiga', :style => {'text-shadow' => '#444 2px -2px 2px', :color => 'white'}
        end
        div :style => { :padding => '10px' } do
          input :id => :textfield
          button :id => :add_new_record, :text => 'Add New Entry'
          grid  :id => :movies_grid,
                :store => MovieStore,
                :columns => [:id, :title]
        end
      end
    end

    button = get_element :add_new_record
    textfield = get_element :textfield
    grid = get_element :movies_grid

    grid.load

    button.onclick do
      add_new_movie
    end

    textfield.onkeypress do |key|
      add_new_movie if key.to_i == 13
    end

  end

  def add_new_movie
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
