class Grid < Element
  attr_accessor :items,:store

  def initialize options = {}
    super options
    @store = options[:store]
    @element_type = 'table'
    @columns = options[:columns]
  end

  def load
    records = @store.all self
    records.each{|x| add_item x }
  end

  def add_item record
    row = Element.new :app => @app, :element_type => :tr
    add_element row

    @columns.each do |c|
      item = Element.new :app => @app, :element_type => :td
      row.add_element item
      item.set_inner_html record.send(c)

      item.set_css 'border-width','1px'
      item.set_css 'border-collapse','collapse'
      item.set_css 'padding','5px'
      item.set_css 'border-style','dotted'
      item.set_css 'border-color','gray'
      item.set_css 'background-color','white'

      item.onclick do
        @app.alert 'You clicked ' + record.title
      end

    end

    @items ||=[]
    @items << row

    @records ||= {}
    @records[record.id] = [record,row]

    remove_button = Button.new :app => @app, :text => 'x' do
      @store.remove record
    end

    item = Element.new :app => @app, :element_type => 'td'
    row.add_element item
    item.set_css 'border-width','1px'
    item.set_css 'border-collapse','collapse'
    item.set_css 'padding','5px'
    item.set_css 'border-style','dotted'
    item.set_css 'border-color','gray'
    item.set_css 'background-color','white'
    item.set_css 'width','20px'

    item.add_element remove_button
  end

  def remove(record)
    record,dom_row =  @records[record.id]
    dom_row.remove_own_element
    @records.delete record.id
  end

  def onremove &block
    @onremove_callback = block
  end

  def setup

    set_css 'border-width','1px'
    set_css 'border-collapse','collapse'
    set_css 'border-spacing','2px'
    set_css 'border-style','solid'
    set_css 'border-color','gray'
    set_css 'background-color','white'
    set_css 'width','100%'

    @header = Element.new :app => @app, :element_type => 'tr'
    add_element @header

    (@columns + ['']).each do |c|
      item = Element.new :app => @app, :element_type => 'th'
      @header.add_element item
      item.set_inner_html c.to_s

      item.set_css 'border-width','1px'
      item.set_css 'border-collapse','collapse'
      item.set_css 'padding','5px'
      item.set_css 'border-style','dotted'
      item.set_css 'border-color','gray'
      item.set_css 'background-color','white'
      
    end

  end

end
