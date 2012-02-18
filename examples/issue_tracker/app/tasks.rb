class Silverforge < Nadeshiko::Application
  module Tasks

    def create_new_issue
      get_element(:new_issue_text_field).val do |value|
        if value != ''
          get_element(:new_issue_text_field).val ''
          issue = Task.new :description => value
          issue.save!
          get_element(:icebox).append_record issue, :notify => true
        end
      end
    end

  end
end
