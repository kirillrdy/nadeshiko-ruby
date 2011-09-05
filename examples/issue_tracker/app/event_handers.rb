module EventHandlers
  def issue_events

      get_element(:new_issue_text_field).keydown do |key|
      if key.to_i == 13
        create_new_issue
      end
    end

    get_element(:add_new_issue_button).click do
      create_new_issue
    end


    get_element(:list_of_issues).sortupdate do |moved_element_id|
      batch_messages do
        move_element moved_element_id
      end
    end
  end

end
