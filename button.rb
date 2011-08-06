class Button < Element
  def initialize title, &block
    super()
    @element_type = 'button'
    @title = title
    @onclick = block
  end

  def setup
    set_inner_html @title
    onclick &@onclick
  end

end
