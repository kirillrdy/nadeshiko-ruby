class Button < Element
  def initialize app,title, &block
    super(app)
    @element_type = 'button'
    @title = title
    @onclick = block
  end

  def setup
    set_inner_html @title
    onclick &@onclick
  end

end
