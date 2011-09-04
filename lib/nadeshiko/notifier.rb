module Nadeshiko
  class Notifier

    def self.bind event_name, &block
      @blocks ||={}
      @blocks[event_name] ||= []
      @blocks[event_name] << block
    end

    #TODO add unbind

    def self.trigger event_name, *args
      @blocks[event_name].each do |x|
        x.call *args
      end
    end

  end
end
