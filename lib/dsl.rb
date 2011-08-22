module Dsl

  attr_accessor :children, :element_type, :args


  
end

class Node
  include Dsl
  def initialize(element_type)
    @element_type = element_type
    @children = []
  end
end
