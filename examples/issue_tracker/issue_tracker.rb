require_relative 'boot'

class IssueTracker < Nadeshiko::Application
  def onstart


    input :id => :new_issue_text_field
    button :id => :add_new_issue_button, :text => 'Add New Issue'

    div :id => :list_of_issues do
      Issue.all.each do |issue|
        add_issue_to_list issue
      end
    end.sortable

    get_element(:add_new_issue_button).click do
      get_element(:new_issue_text_field).val do |value|
        issue = Issue.new :description => value
        issue.save!
        add_elements_to(:list_of_issues) do
          add_issue_to_list issue
        end
      end
    end

  end

  def add_issue_to_list issue
    issue_div = div do
      span :text => issue.description
      x = button :text => 'x'
      x.click do
        issue.destroy
        issue_div.remove
      end
    end
  end

end

Nadeshiko::Server.run IssueTracker
