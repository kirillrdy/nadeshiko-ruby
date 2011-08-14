class Dialog < Element

  def initialize options={}
    super options
    @header_id = generate_random_id
    @content_id = generate_random_id
  end

  def show &block
    @content = block
    content = app.get_element @content_id
    content.add_elements &block
    show_element
  end


  def setup

    set_css 'display','none'

    top_heading = { :padding => '5px',
                  'margin-top' => '0px',
                  'margin-bottom' => '0px',
                  :background => '-webkit-linear-gradient(top, #1e5799 0%, #2989d8 50%, #207cca 51%, #7db9e8 100%)'
                  }
    titles_style = {'text-shadow' => '#444 2px -2px 2px', :color => 'white'}

    background = {'background-color' => '#eee'}
    border = {:border => '1px solid black'}
    round_top = {'border-radius'=> '5px'}
    float_right = {:float => :right}

    dialog_style = {:position => 'absolute'}.merge(background).merge(border).merge(round_top)
    dialog_style.each_pair{|k,v| set_css k,v }

    header_id = @header_id
    content_id = @content_id

    add_elements do
      h4 :id => header_id, :text => 'Dialog' , :style => top_heading.merge(titles_style)
      div :id => content_id, :style => { :padding => '5px' }
    end # add elements
    
  end
  
end
