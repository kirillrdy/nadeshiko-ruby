require_relative 'boot'

class IssueTracker < Nadeshiko::Application
  def onstart

    style do
      {
        '#list_of_issues' => {
          :height => '90%',
          :width => '400px',
          #:border => '1px solid gray'
          :background => '#efe',
          'border-radius' => '3px',
        },
        '#footer' => {
          :margin => :auto,
          :width => '200px'
        },
        '.issue' => {
          #:width => '400px',
          :width => '100%',
          'border-radius' => '3px',
          :border => '1px solid gray',
          :background => '#eee'
        },
        '.issue-description' => {
          :width => '330px'
        },
        '.issue-buttons' => {
          'float' => 'right'
        }
      }
    end

    h1 :text => 'Non-pivotal tracker (TM)'

    div do
      input :id => :new_issue_text_field
      button :id => :add_new_issue_button, :text => 'Add New Issue'
    end

    span :text => 'Icebox'
    div :id => :list_of_issues do
      Issue.all.each do |issue|
        add_issue_to_list issue
      end
    end.sortable

    div :id => :footer, :text => "Powered by Nadeshiko #{Nadeshiko::VERSION}"

    Nadeshiko::Notifier.notify_on :issue_create do |issue|
      add_elements_to(:list_of_issues) do
        add_issue_to_list issue
      end
    end

    Nadeshiko::Notifier.notify_on :issue_moved do |moved_issue_element_id,target_id,special_case|
      moved_element = get_element(moved_issue_element_id)
      target = get_element(target_id)
      if special_case
        moved_element.insert_before(target)
      else
        moved_element.insert_after(target)
      end
    end

    Nadeshiko::Notifier.notify_on :issue_destroyed do |removed_id|
      get_element(removed_id).remove
    end

    get_element(:add_new_issue_button).click do
      get_element(:new_issue_text_field).val do |value|
        get_element(:new_issue_text_field).val ''
        issue = Issue.new :description => value
        issue.save!
        Nadeshiko::Notifier.trigger :issue_create, issue
      end
    end


    get_element(:list_of_issues).sortupdate do |moved_element_id|
      move_element moved_element_id
    end

  end

  def move_element moved_element_id

    moved_element = get_element(moved_element_id)
    moved_element.index do |index|
      issue = moved_element.options[:record]
      issue.reload

      old_pos = issue.sort_order
      new_pos = index.to_i

      range = old_pos > new_pos ? (new_pos..old_pos-1) : (old_pos..new_pos)
      sort_orders = range.to_a
      issues_to_update = Issue.where(:sort_order => sort_orders )

      Issue.transaction do
        if old_pos > new_pos
          issues_to_update.each{|x| x.sort_order +=1 ; x.save! }
        else
          issues_to_update.each{|x| x.sort_order -=1 ; x.save! }
        end
      end

      issue.sort_order = new_pos
      issue.save!

      # Notification thingy
      moved_element.index do |index|
        if index.to_i == 0
          moved_element.next do |next_id|
            Nadeshiko::Notifier.trigger :issue_moved, moved_element_id,next_id, true
          end
        else
          moved_element.prev do |prev_id|
            Nadeshiko::Notifier.trigger :issue_moved, moved_element_id,prev_id, false
          end
        end
      end

    end
  end

  def add_issue_to_list issue
    issue_div = div :id => "issue_#{issue.id}", :record => issue, :class => 'issue' do
      
      story_description = "#{issue.id}: #{issue.description}"
      
      span :text => story_description, :class => 'issue-description'
      x = div :text => 'x', :class => 'issue-buttons'
      x.click do
        issue.destroy
        Nadeshiko::Notifier.trigger :issue_destroyed, issue_div.id
        #issue_div.remove
      end
    end
  end

end

Nadeshiko::Server.run IssueTracker
