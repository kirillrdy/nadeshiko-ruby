class Grid < Element
  attr_accessor :items,:store

  def initialize app, store
    super app
    @store = store
    @element_type = 'table'
  end

  def load
    records = @store.all self
    records.each{|x| add_item x }
  end

  def add_item record
    row = Element.new(@app)
    row.element_type = 'tr'
    add_element row

    columns = [:id,:title]
    
    columns.each do |c|
      item = Element.new(@app)
      item.element_type = 'td'
      row.add_element item
      item.set_inner_html record.send(c)

      item.onclick do
        alert 'You clicked ' + record.title
      end

    end



    @items ||=[]
    @items << row

    @records ||= {}
    @records[record.id] = [record,row]

    remove_button = Button.new(@app,'x') do
      @store.remove record
    end

    row.add_element remove_button
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
  end

end
