require './lib/nadeshiko'

module Examples
  class HelloWord < Nadeshiko::Application

    def onstart
      span :text => 'Hello World'
    end

  end
end

Nadeshiko::Server.run Examples::HelloWord
