require './lib/nadeshiko'

class Notifier
  def self.onmove &block
    @onmove ||= []
    @onmove << block
  end
  
  def self.move element_id, position
    @onmove.each{|x| x.call element_id,position }
  end
  
end

class HelloWord < Nadeshiko::Application

  def onstart
    ul :id => 'sortable' do
      ['item1','item2','item3','item4'].each do |i|
        li :id => i do
          span :text => i
        end
      end
    end

    Notifier.onmove do |item,prev_item|
      get_element(item).insert_after(get_element(prev_item))
    end

    get_element(:sortable).sortable do |item,prev_item|
      Notifier.move item,prev_item
    end

  end

end

Nadeshiko::Server.run HelloWord
