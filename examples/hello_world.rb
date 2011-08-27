require './lib/nadeshiko'

class HelloWord < Nadeshiko::Application

  def onstart

    add_elements do
      span :text => 'Hello World'
    end

  end

end

Nadeshiko::Server.run HelloWord
