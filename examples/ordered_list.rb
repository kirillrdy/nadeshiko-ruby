require './lib/nadeshiko'

class OrderedList < Nadeshiko::Application

  class << self
    attr_accessor :number_runner
  end

  @number_runner = 0

  def onstart

    input :id => 'textfield'
    button :id => 'add_item', :text => 'add'

    ul :id => 'sortable' do
      ['item1','item2','item3'].each do |i|
        li :id => i do
          span :text => i
        end
      end
    end


    # subscribe to notifications
    Nadeshiko::Notifier.notify_on :item_moved_to_top do |moved_element_id,next_element_id|
      e = get_element(moved_element_id)
      e.insert_before(get_element(next_element_id))
    end

    Nadeshiko::Notifier.notify_on :item_moved do |moved_element_id,prev_element_id|
      e = get_element(moved_element_id)
      e.insert_after(get_element(prev_element_id))
    end

    Nadeshiko::Notifier.notify_on :item_added do |value|
      add_elements_to(:sortable) do
        li :id => 'new_item_' + self.class.number_runner.to_s do
          span :text => value
        end
      end
    end

    # Hook into events
    get_element(:sortable).sortable


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

    get_element(:add_item).click do
      get_element(:textfield).val do |value|
        self.class.number_runner += 1
        Nadeshiko::Notifier.trigger :item_added, value
      end
    end

  end

end

Nadeshiko::Server.run OrderedList
