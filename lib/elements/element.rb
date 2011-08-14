class Element

  attr_accessor :app
  attr_accessor :parent_id, :id,:element_type

  def initialize options = {}
    default_options = {
      :app => options[:app],
      :id => Digest::SHA1.hexdigest(rand.to_s)[0..6],
      :element_type => 'div'
    }

    options =  default_options.merge options

    @app =  options[:app]
    @id = options[:id].to_s
    @element_type = options[:element_type]
    @text = options[:text]
    @style = options[:style]
  end

  def add_element element
    element.parent_id = self.id
    element.add_own_element_to_parent
    element.setup
  end



  def add_elements &block
    root = Node.new :div
    root.instance_eval &block

    root.children.each do |child|
      @app.parse_nodes child, self
    end

  end


  def show_element
    @app.dom_on_sockets.show_element @id
  end

  def add_own_element_to_body
    @app.dom_on_sockets.add_element_to_body @element_type,@id
    setup
  end

  def add_own_element_to_parent
    @app.dom_on_sockets.add_element @element_type,@id,@parent_id
    setup
  end

  def remove_own_element
    @app.dom_on_sockets.remove_element @id
  end

  def set_inner_html text
    @app.dom_on_sockets.set_inner_html @id, text
  end

  def set_css property,value
    @app.dom_on_sockets.set_css @id,property,value
  end

  def onclick &block
    @app.dom_on_sockets.add_onclick @id,&block
  end

  def onkeypress &block
    @app.dom_on_sockets.add_onkeypress @id,&block
  end

  def get_value &block
    @app.dom_on_sockets.get_value @id, &block
  end

  def set_value value
    @app.dom_on_sockets.set_value @id, value
  end

  def make_draggable handle_id
    @app.dom_on_sockets.make_draggable @id,handle_id
  end

  def setup
    #set_css 'border','1px solid black'
    set_inner_html @text if @text
    
    if @style
      @style.each_pair do |k,v|
        set_css k,v
      end
    end
    
    #set_css 'width','200px'

#    onclick do
#      alert 'Hello from Kirill'
#    end
  end

end
