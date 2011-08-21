class Grid2 < Element
  attr_accessor :items,:columns

  def initialize options = {}
    super options
    @columns = options[:columns]
    @tbody_id = generate_random_id
  end

  def add_item record

    columns = @columns

    add_elements do
      tr do
        columns.each do |c|
          td :text => record.send(c), :style => default_style
        end
        td :text => 'Edit,Delete'
      end
    end

    @items ||=[]
    @items << row

    @records ||= {}
    @records[record.id] = [record,row]

#    remove_button = Button.new :app => @app, :text => 'x' do
#      @store.remove record
#    end

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

    default_style2 = default_style
    columns = @columns

    add_elements do
      table :style => default_style2.merge({:width => '100%'}) do
        thead do
          tr do
            (columns+['']).each do |c|
              th :text => c.to_s, :style => default_style2.merge({'background-color'=>'#eee'})
            end
          end
        end
        tbody :id => tbody_id
      end
    end

  end


  def default_style
    {
      'border-width' => '1px',
      'border-collapse' => 'collapse',
      'border-spacing' => '2px',
      'border-style' => 'solid',
      'border-color' => 'gray',
      'background-color' => 'white'
    }
  end

end
