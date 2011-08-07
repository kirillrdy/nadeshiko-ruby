class MovieStore

  class << self
    attr_accessor :elements
  end

  def self.add hash
    new_movie = Movie.create! hash
    self.elements.each do |element|
      element.add_item new_movie
    end
  end


  def self.remove record
    Movie.find(record.id).destroy
    self.elements.each do |element|
      element.remove record
    end
  end


  def self.all element
    self.elements ||= []
    self.elements << element
    Movie.all
  end
  
end
