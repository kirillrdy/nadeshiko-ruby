module Nadeshiko::Jquery
  # Shows hidden elements
  # has no effect if element already visible
  def show
    @app.dom_on_sockets.show_element @id
  end

  # Empties content of the element
  def empty
    @app.dom_on_sockets.empty @id
  end

  def add_class class_name
    @app.dom_on_sockets.add_class @id,class_name
  end

  #  #TODO finish
  #  # Appends self to either known parent or body
  #  def append_self # assumes it knows parent, or appends to body
  #  end

  #  #TODO
  #  # appends to self
  #  def append content
  #  end
  #  
  #  # append self to parent
  #  def append_to parent_id
  #  end

  #  #TODO prepend finish
  #  # Make same methods as above for prepending
  #  def prepend_self
  #  end

  # Removes element from DOM
  def remove_element
    @app.dom_on_sockets.remove_element @id
  end

  # sets inner text for element
  # TODO rename to set_html or html to be consitent with JQuery
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

  def sortable &block
    @app.dom_on_sockets.sortable @id,&block
  end

  def insert_after element
    @app.dom_on_sockets.insert_after @id,element.id
  end

end
