class Button < Element
  def initialize options = {}, &block
    super(options)
    @element_type = 'button'
    @text = options[:text]
    @onclick = block
  end

  def setup
    set_inner_html @text
    onclick &@onclick
  end

end
