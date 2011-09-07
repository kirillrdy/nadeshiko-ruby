class IssueTracker < Nadeshiko::Application
  class Issue < ActiveRecord::Base

    def self.load_in_order ids
      self.transaction do
        return ids.map{|x| self.find x }
      end
    end

  end
end
