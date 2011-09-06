class IssueTracker < Nadeshiko::Application
module Layout

  def initial_layout
    h1 :text => 'Non-pivotal tracker (TM)'

    div :class => 'row show-grid' do
      div :class => 'span8 column' do
        h4 :text => 'Icebox'
        div do
          input :id => :new_issue_text_field, :class => 'xlarge'
          button :id => :add_new_issue_button, :text => 'Add New Issue', :class => 'btn primary'
        end
        icebox_panel
      end
      div :class => 'span8 column' do
        h4 :text => 'Search'
        input :id => :search_issue_text_field
        button :id => :search_issue_button, :text => 'Search', :class => 'btn small'
        div :class => 'list-of-issues'
      end
      div :class => 'span8 column' do
        h4 :text => 'My Work'
        span :text => 'other things here'
        #icebox_panel
        div  :class => 'list-of-issues'
      end
    end

    div :id => :footer, :text => "Powered by Nadeshiko #{Nadeshiko::VERSION}"
  end

  def icebox_panel
    div :id => :list_of_issues, :class => 'list-of-issues' do
      Issue.all.each do |issue|
        add_issue_to_list issue
      end
    end.sortable
  end

end
end
