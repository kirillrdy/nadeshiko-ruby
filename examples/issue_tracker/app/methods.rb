module Methods
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

  def create_new_issue
    get_element(:new_issue_text_field).val do |value|
      if value != ''
        get_element(:new_issue_text_field).val ''
        issue = Issue.new :description => value
        issue.save!
        Nadeshiko::Notifier.trigger :issue_create, issue
      end
    end
  end

  def add_issue_to_list issue
    issue_div = div :id => "issue_#{issue.id}", :record => issue, 
      #:class => "alert-message block-message warning" do
      :class => "well" do

      story_description = "#{issue.id}: #{issue.description}"

      div :text => story_description, :class => 'issue-description left'
      div :text => 'Finish', :class => 'btn success right'
      x = div :text => 'Delete', :class => 'btn danger right'
      x.click do
        issue.destroy
        Nadeshiko::Notifier.trigger :issue_destroyed, issue_div.id
      end
    end
  end
end
