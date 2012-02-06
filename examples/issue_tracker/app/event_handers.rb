class IssueTracker < Nadeshiko::Application
  module EventHandlers

    def nav_bar_events

      get_element(:home_section_link).click do
        get_element(:main_body).empty
        get_element(:home_li).add_class 'active'
        get_element(:admin_li).remove_class 'active'
        batch_messages do
          issues_layout
          issue_events
        end
      end

      get_element(:admin_section_link).click do
        get_element(:main_body).empty
        get_element(:admin_li).add_class 'active'
        get_element(:home_li).remove_class 'active'
        batch_messages do
          add_admin_layout
        end
      end

    end

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
