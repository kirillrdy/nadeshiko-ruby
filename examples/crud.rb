require './lib/nadeshiko'


class CrudExample < Nadeshiko::Application

  def onstart

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

    main_style = { :margin => :auto, :width => '900px','margin-top' => '5px' }.merge(background).merge(border).merge(round_top)
    header_style = top_heading.merge({ :height => '80px' })
    dialog_style = {:position => 'absolute'}.merge(background).merge(border).merge(round_top)
    titles_style = {'text-shadow' => '#444 2px -2px 2px', :color => 'white'}


    default_table_style = {
      'border-width' => '1px',
      'border-collapse' => 'collapse',
      'border-spacing' => '2px',
      'border-style' => 'solid',
      'border-color' => 'gray',
      'background-color' => 'white'
    }

    style do
      {
        'body' => {
          'background-color' => '#9aa',
          'padding' => '0px',
          'margin' => '0px'
        },
        '.main_content' => main_style,
        '.header' => header_style,
        '.title' => titles_style,
        '.float_right' => float_right
      }
    end




    div :id => :main, :class => :main_content do
      div :class => :header do
        h1 :text => 'List of Records', :class => :title
      end
      div :style => { :padding => '10px' } do
        div :class => :float_right do
          input :id => :textfield
          button :id => :add_new_record, :text => 'Add New Entry'
          button :id => :show_dialog_button, :text => 'show demo dialog'
        end
        grid2  :id => :movies_grid2,
              :columns => [:id, :title]
        
      end
    end


    button = get_element :add_new_record
    textfield = get_element :textfield

    Nadeshiko::Notifier.notify_on 'item_add' do |record|
      add_movie_to_table record
    end


    button.click do
      create_new_movie
    end

#    textfield.onkeypress do |key|
#      create_new_movie if key.to_i == 13
#    end

    get_element(:show_dialog_button).click do
      show_demo_dialog
    end

  end


  def add_movie_to_table movie

    grid2 = get_element :movies_grid2

    grid2.add_item do
      tr do
        td :text => movie.id
        td :text => movie.title
        td
      end
    end
  end


  def create_new_movie
    textfield = get_element :textfield
    textfield.val do |value|
      if value != ''
        m = Struct.new(:id,:title).new
        m.title = value
        Nadeshiko::Notifier.trigger 'item_add', m
      else
        alert 'Please enter something'
      end
      textfield.val ''
    end
  end



  def show_demo_dialog
    dialog = Nadeshiko::Dialog.new :app => self

    dialog.show do
      table :style => {:width => '100%'} do
        ['Title','Year','Some other field'].each do |x|
          tr do
            td :text => x
            td do
              input
            end
          end
        end
      end
      div :style => {'margin' => '10px','float' => 'right'} do
        button :text => 'Close', :id => :close_dialog_button
        button :text => 'Create'
      end
    end

    get_element(:close_dialog_button).click do
      dialog.remove_element
    end

  end

end

Nadeshiko::Server.run CrudExample
