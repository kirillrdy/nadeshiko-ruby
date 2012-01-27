require './lib/nadeshiko'

# This example demonstrates how to create an ordered list 
# with live updates on addition of new items and on move of an item
class OrderedList < Nadeshiko::Application


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

    # Made list sortable, jQuery call
    get_element(:sortable).sortable


    # Event on sortupdate
    # fired when one of users moved item
    get_element(:sortable).sortupdate do |item_id|

      moved_element = get_element(item_id)

      moved_element.index do |index|
        if index.to_i == 0
          # next is just a jQuery method
          moved_element.next do |next_element_id|
            Nadeshiko::Notifier.trigger :item_moved_to_top,moved_element.id,next_element_id
          end
        else
          # prev is just a jQuery method
          moved_element.prev do |prev_element_id|
            Nadeshiko::Notifier.trigger :item_moved,moved_element.id,prev_element_id
          end
        end
      end
    end

    # This is triggered when user adds new item
    get_element(:add_item).click do
      get_element(:textfield).val do |value|
        # if user trying to add an empty item, we should
        # just ignore, or perhaps alert
        if value != ''

          # Notify clients of new value being added
          Nadeshiko::Notifier.trigger :item_added, value

          # clear text box for next entry
          get_element(:textfield).val ''
        end
      end
    end

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
        li do
          span :text => value
        end
      end
    end


  end

end

Nadeshiko::Server.run OrderedList
