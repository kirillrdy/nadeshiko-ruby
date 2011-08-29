require './lib/nadeshiko'

class HelloWord < Nadeshiko::Application

  def onstart
    span :text => 'Hello World'
  end

end

Nadeshiko::Server.run HelloWord
