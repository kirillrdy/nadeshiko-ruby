require './lib/nadeshiko'

class HelloWord < Nadeshiko::Application

  def onstart
    div :id => :target

    append_to :target do
      span :text => 'Hello'
    end

    prepend_to :target do
      span :text => 'I should be first'
      span :text => 'I should be second'
    end

    append_to :target do
      span :text => 'I should be after hello'
    end

  end

end

Nadeshiko::Server.run HelloWord
