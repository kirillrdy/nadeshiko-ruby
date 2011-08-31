require './lib/nadeshiko'

class HelloWord < Nadeshiko::Application

  def onstart
    input :id => 'textfield'
    button :id => 'add_item', :text => 'add'

    ul :id => 'sortable' do
      ['item1','item2','item3'].each do |i|
        li do
          span :text => i
        end
      end
    end


    # subscribe to notifications
    Nadeshiko::Notifier.notify_on :item_moved do |item,prev_item|
      e = get_element(item)
      e.insert_after(get_element(prev_item)) if e
    end

    Nadeshiko::Notifier.notify_on :item_added do |value|
      add_elements_to(:sortable) do
        li do
          span :text => value
        end
      end
    end

    # Hook into events
    get_element(:sortable).sortable do |item,prev_item|
      Nadeshiko::Notifier.trigger :item_moved,item,prev_item
    end

    get_element(:add_item).onclick do
      get_element(:textfield).get_value do |value|
        Nadeshiko::Notifier.trigger :item_added, value
      end
    end

  end

end

Nadeshiko::Server.run HelloWord
