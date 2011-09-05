require './lib/nadeshiko'

# This example demonstrates how to create an ordered list 
# with live updates on addition of new items and on move of an item
class OrderedList < Nadeshiko::Application

  class << self

    # I added a global counter for items created so that i can keep a track of number of items created
    # since this example doesnt acctually persist items list
    attr_accessor :number_runner
  end

  @number_runner = 0

  def onstart

    input :id => :textfield
    button :id => :add_item, :text => 'add'

    ul :id => :sortable do
      ['item1','item2','item3'].each do |i|
        li :id => i do
          span :text => i
        end
      end
    end

    # Made list sortable
    get_element(:sortable).sortable


    # subscribe to notifications
    Nadeshiko::Notifier.bind :item_moved_to_top do |moved_element_id,next_element_id|
      e = get_element(moved_element_id)
      e.insert_before(get_element(next_element_id))
    end

    Nadeshiko::Notifier.bind :item_moved do |moved_element_id,prev_element_id|
      e = get_element(moved_element_id)
      e.insert_after(get_element(prev_element_id))
    end

    Nadeshiko::Notifier.bind :item_added do |value|
      append_to(:sortable) do
        li :id => 'new_item_' + self.class.number_runner.to_s do
          span :text => value
        end
      end
    end



    # Event on sortupdate
    # fired when one of users moved item
    get_element(:sortable).sortupdate do |item_id|

      moved_element = get_element(item_id)

      moved_element.index do |index|
        if index.to_i == 0
          moved_element.next do |next_element_id|
            Nadeshiko::Notifier.trigger :item_moved_to_top,moved_element.id,next_element_id
          end
        else
          moved_element.prev do |prev_element_id|
            Nadeshiko::Notifier.trigger :item_moved,moved_element.id,prev_element_id
          end
        end
      end
    end

    # This is triggered when user adds new item
    get_element(:add_item).click do
      get_element(:textfield).val do |value|
        self.class.number_runner += 1
        Nadeshiko::Notifier.trigger :item_added, value
      end
    end

  end

end

Nadeshiko::Server.run OrderedList
