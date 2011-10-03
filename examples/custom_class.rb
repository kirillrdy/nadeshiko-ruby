require './lib/nadeshiko'

module Nadeshiko
  class List < Element

    def initialize options = {}
      super
      @element_type = :div
    end

    def setup
      text 'I am custom class'
    end

  end
end

class CustomClass < Nadeshiko::Application

  def onstart
    span :text => 'Hello World'
    
    # This magically looks up class List under Nadeshiko namespace
    list :id => :custom_list1
  end

end

Nadeshiko::Server.run CustomClass
