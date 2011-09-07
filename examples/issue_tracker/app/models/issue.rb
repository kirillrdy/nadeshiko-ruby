class IssueTracker < Nadeshiko::Application
class Issue < ActiveRecord::Base
  default_scope order(:sort_order)

#  before_create do
#    last_issue = Issue.order(:sort_order).last
#    self.sort_order = last_issue ? last_issue.sort_order + 1 : 0
#  end

  after_destroy do
    Issue.transaction do
      Issue.where(['sort_order > ?',self.sort_order]).each do |x|
        x.sort_order -= 1
        x.save
      end
    end
  end

  def self.load_in_order ids
    self.transaction do
      return ids.map{|x| self.find x }
    end
  end

end
end
