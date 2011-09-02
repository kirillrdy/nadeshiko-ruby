class Issue < ActiveRecord::Base
  default_scope order(:sort_order)
  before_create do
    last_issue = Issue.order(:sort_order).last
    self.sort_order = last_issue ? last_issue.sort_order + 1 : 0
  end
end
