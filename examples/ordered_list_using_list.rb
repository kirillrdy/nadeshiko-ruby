require './lib/nadeshiko'

# This example demonstrates how to create an ordered list 
# with live updates on addition of new items and on move of an item
class OrderedList < Nadeshiko::Application

  def onstart

    input :id => :textfield
    button :id => :add_item, :text => 'add'

    list :id => :list, :sortable => true, :notify => true

    list = get_element :list

    list.item_renderer do |record|
      div :text => record.name
    end

    # This is triggered when user adds new item
    get_element(:add_item).click do
      get_element(:textfield).val do |value|
        record = Struct.new(:id,:name).new
        record.name = value
        record.id = rand
        get_element(:list).append_record record,:notify => true
      end
    end

  end

end

Nadeshiko::Server.run OrderedList
