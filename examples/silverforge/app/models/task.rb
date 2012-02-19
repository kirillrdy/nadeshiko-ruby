class Silverforge < Nadeshiko::Application
  class Task < ActiveRecord::Base

    belongs_to :project
    has_many :task_logs


    def self.load_in_order ids
      self.transaction do
        return ids.map{|x| self.find x }
      end
    end

  end
end
