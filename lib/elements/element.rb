class Element

  attr_accessor :app
  attr_accessor :parent_id, :id,:element_type

  def initialize(options = {})
    default_options = {
      :app => options[:app],
      :id => generate_random_id,
      :element_type => 'div'
    }

    #@children = []

    options =  default_options.merge options

    @app =  options[:app]
    @id = options[:id].to_s
    @element_type = options[:element_type]
    @text = options[:text]
    @style = options[:style]
  end

  def method_missing element_type,*args, &block

    html_based_elements = [:h1,:div,:input,:button,:table,:tr,:th,:td,:thead]
    magic_based_elements = [:grid2]

    super unless (html_based_elements + magic_based_elements).include? element_type

    options = args.first || {}

    options.merge!({:app => app,:element_type => element_type})

    case element_type
      when :grid2
        a = Grid2.new(options)
      else
        a = Element.new(options)
    end


    self.add_element a

    #debugger
    #@children << a

    a.instance_eval(&block) if block_given?

  end


  def generate_random_id
    Digest::SHA1.hexdigest(rand.to_s)[0..6]
  end

  def add_element element
    element.parent_id = self.id
    element.add_own_element_to_parent
  end

  def add_elements &block
    self.instance_eval &block
  end

  def show_element
    @app.dom_on_sockets.show_element @id
  end

  def add_own_element_to_parent
    if parent_id.empty?
      @app.dom_on_sockets.add_element_to_body @element_type,@id
    else
      @app.dom_on_sockets.add_element @element_type,@id,@parent_id
    end
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
