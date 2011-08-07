class Store

  class << self
    attr_accessor :items
    attr_accessor :elements
  end

  def self.add app,item
    self.items << item
    self.elements.each do |element|
      next if app == element.app
      element.add_item item
    end
  end

  def self.all element
    self.elements ||= []
    self.elements << element
    self.items ||= ['First hardwired item']
    self.items
  end
  
end
