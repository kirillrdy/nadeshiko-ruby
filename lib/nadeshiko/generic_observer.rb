class Nadeshiko::GenericObserver

  def self.onadd &block
    @onadd ||= []
    @onadd << block
  end

  def self.add val
    @onadd.each do |x|
      x.call val
    end
  end

end
