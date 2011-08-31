module Nadeshiko
  class Notifier

    def self.notify_on event_name, &block
      @blocks ||={}
      @blocks[event_name] ||= []
      @blocks[event_name] << block
    end

    def self.trigger event_name, *args
      @blocks[event_name].each do |x|
        x.call *args
      end
    end

  end
end
