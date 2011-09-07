class IssueTracker < Nadeshiko::Application
  module EventHandlers
    def issue_events

      get_element(:new_issue_text_field).keydown do |key|
        if key.to_i == 13
          create_new_issue
        end
      end

      get_element(:add_new_issue_button).click do
        batch_messages do
          create_new_issue
        end
      end

    end

  end
end
