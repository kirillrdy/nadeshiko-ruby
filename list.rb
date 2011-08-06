class List < Element
  attr_accessor :items



  def add_item string
    item = Element.new
    add item

    item.set_inner_html string
    item.onclick do
      alert 'You clicked ' + string
    end
    @items ||=[]
    @items << item
  end

  def setup
  end

end
