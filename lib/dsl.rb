module Dsl

  attr_accessor :children, :element_type, :args

  def method_missing method,*args, &block
    a = Node.new(method)
    a.args = args
    a.instance_eval(&block) if block_given?
    @children << a
  end
  
end

class Node
  include Dsl
  def initialize(element_type)
    @element_type = element_type
    @children = []
  end
end
