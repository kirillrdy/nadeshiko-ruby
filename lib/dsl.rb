module Dsl

  attr_accessor :children, :method

  def method_missing method, *args, &block
    a = Node.new(method,*args)
    a.instance_eval(&block) if block_given?
    @children ||= []
    @children << a
  end
  
end

class Node
  include Dsl
  def initialize(name)
    @name = name
  end
end


#p = Node.new :root

#p.instance_eval do
#  hbox do
#    vbox do
#      text 'a'
#      text 'b'
#      button 'hello'
#    end
#    button 'hello'
#  end
#end

#puts p.inspect
