class List < Element
  attr_accessor :items

  def add_item string
    row = Element.new(@app)
    add_element row

    item = Element.new(@app)
    row.add_element item

    item.set_inner_html string
    item.set_css 'display','inline'
    item.onclick do
      alert 'You clicked ' + string
    end
    @items ||=[]
    @items << row

    remove_button = Button.new(@app,'x') do
      remove item
      row.remove_own_element
    end

    row.add_element remove_button
  end

  def remove(item)

    item.remove_own_element
    @items.delete item
    @onremove_callback.call item if @on_add_button_click
  end

  def onremove &block
    @onremove_callback = block
  end

  def setup
  end

end
