class MyApp < App

  def onstart

    # Setting body style
    @dom_on_sockets.set_css_by_selector 'body','background-color','#9aa'
    @dom_on_sockets.set_css_by_selector 'body','padding','0px'
    @dom_on_sockets.set_css_by_selector 'body','margin','0px'
    # Theme presets
    top_heading = { :padding => '5px',
                  'margin-top' => '0px',
                  'margin-bottom' => '0px',
                  :background => '-webkit-linear-gradient(top, #1e5799 0%, #2989d8 50%, #207cca 51%, #7db9e8 100%)'
                  }

    background = {'background-color' => '#eee'}
    border = {:border => '1px solid black'}
    round_top = {'border-radius'=> '5px'}
    float_right = {:float => :right}

    main_style = { :margin => :auto, :width => '1000px','margin-top' => '5px' }.merge(background).merge(border).merge(round_top)
    header_style = top_heading.merge({ :height => '80px' })
    dialog_style = {:position => 'absolute'}.merge(background).merge(border).merge(round_top)
    titles_style = {'text-shadow' => '#444 2px -2px 2px', :color => 'white'}


    add_elements do
      div :id => :main, :style => main_style do
        div :style => header_style do
          h1 :text => 'Eiga', :style => titles_style
        end
        div :style => { :padding => '10px' } do
          div :style => float_right do
            input :id => :textfield
            button :id => :add_new_record, :text => 'Add New Entry'
            button :id => :show_dialog_button, :text => 'show demo dialog'
          end
          grid  :id => :movies_grid,
                :store => MovieStore,
                :columns => [:id, :title]
        end
      end
      #dialog :id => :dialog
    end


    button = get_element :add_new_record
    textfield = get_element :textfield
    grid = get_element :movies_grid

    grid.load

    button.onclick do
      add_new_movie
    end

    get_element(:show_dialog_button).onclick do
      show_demo_dialog
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

  def show_demo_dialog
    dialog = Dialog.new :app => self
    dialog.add_own_element_to_body

    dialog.show do
     table :style => {:width => '100%'} do
        tr do
          td :text => 'Title'
          td do
            input
          end
        end
        tr do
          td :text => 'Year'
          td do
            input
          end
        end
        tr do
          td :text => 'Some other thing'
          td do
            input
          end
        end
      end
      div :style => {'margin' => '10px','float' => 'right'} do
        button :text => 'Close', :id => :close_dialog_button
        button :text => 'Create'
      end
    end

    get_element(:close_dialog_button).onclick do
      dialog.remove_own_element
    end

    @dom_on_sockets.get_screen_size do |width,height|

      dialog_width = 400
      dialog_height = 300
      screen_width = width.to_i
      screen_heigth = height.to_i
      
      left = (screen_width / 2) - ( dialog_width / 2)
      top = (screen_heigth / 2) - ( dialog_height / 2)

      dialog.set_css 'width',dialog_width
      #dialog.set_css 'height',dialog_height
      dialog.set_css 'left',left
      dialog.set_css 'top',top

      dialog.make_draggable :dialog_header

    end
  end

end
