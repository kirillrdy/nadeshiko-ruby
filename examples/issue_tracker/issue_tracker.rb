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

    get_element(:list_of_issues).sortupdate do |moved_element_id|
      puts moved_element_id
      moved_element = get_element(moved_element_id)
      moved_element.index do |index|
        issue = moved_element.options[:record]

        issue.reload

        old_pos = issue.sort_order
        new_pos = index.to_i
        
        range = old_pos > new_pos ? (new_pos..old_pos-1) : (old_pos..new_pos)

        sort_orders = range.to_a

        puts "moving #{old_pos} to #{new_pos}"
        puts "will search for sort_order #{sort_orders}"
        issues_to_update = Issue.where(:sort_order => sort_orders )
        puts issues_to_update.map{|x| "#{x.description},#{x.sort_order}" }

        if old_pos > new_pos
          issues_to_update.each{|x| x.sort_order +=1 ; x.save! }
        else
          issues_to_update.each{|x| x.sort_order -=1 ; x.save! }
        end

        puts "setting new position to #{new_pos}"
        issue.sort_order = new_pos
        issue.save!

      end
    end

  end

  def add_issue_to_list issue
    issue_div = div :id => "issue_#{issue.id}", :record => issue do
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
