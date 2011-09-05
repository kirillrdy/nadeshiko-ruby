module Notifications
  def setup_notificaitons
    Nadeshiko::Notifier.bind :issue_create do |issue|
      batch_messages do
        prepend_to :list_of_issues do
          add_issue_to_list issue
        end
      end
    end

    Nadeshiko::Notifier.bind :issue_moved do |moved_issue_element_id,target_id,special_case|
      moved_element = get_element(moved_issue_element_id)
      target = get_element(target_id)
      batch_messages do
        if special_case
          moved_element.effect "highlight",{},3000
          moved_element.insert_before(target)
        else
          moved_element.effect "highlight",{},3000
          moved_element.insert_after(target)
        end
      end
    end

    Nadeshiko::Notifier.bind :issue_destroyed do |removed_id|
      get_element(removed_id).remove
    end
  end
end
