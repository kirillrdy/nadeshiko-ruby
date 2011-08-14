class MyApp < App

  def onstart
  end

  def parse_nodes root, parent = nil

    e = Element.new :app => self
    e.element_type = root.element_type.to_s

    if root.args && root.args.first && root.args.first.is_a?(Hash)
      root.args.first.keys.each do |option|
        value = root.args.first[option]
        case option
          when :id
            e.id = value
        end
      end
    end

    if parent == nil
      e.add_own_element_to_body
      e.setup
    else
      parent.add_element e
    end

    root.children.each do |x|
      parse_nodes x, e
    end

  end

  def add_html &block
    root = Node.new :div
    root.instance_eval &block

    puts root.inspect
    parse_nodes root
  end

  def setup_app

#    add_html do
#      div :id => :main, :style => { :margin => :auto, :width => '100px' } do
#        div :height => '30px' do
#          h1 'Eiga'
#        end
#        input :id => 'textfield'
#        button :id => 'add_new_record', :text => 'Add New Entry'
#        grid :store => MovieStore, :columns => [:id, :title]
#      end
#    end


    main = Element.new :app => self, :id => :main
    main.add_own_element_to_body

    @textfield = Textfield.new :app => self
    main.add_element @textfield

    @textfield.onkeypress do |keypressed|
      on_add_button_click if keypressed.to_i == 13
    end

    @button = Button.new :app => self, :text => 'Add New Entry' do
      on_add_button_click
    end
    main.add_element @button

    e = Element.new :app => self
    main.add_element e

    @list = Grid.new :app => self, :store => MovieStore, :columns => [:id,:title]
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
