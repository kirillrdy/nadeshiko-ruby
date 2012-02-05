class IssueTracker < Nadeshiko::Application
  module Layout

    def initial_layout

      div :class => "navbar" do
        div :class => "navbar-inner" do
          div :class => "container" do
              a :class => 'brand', :text => 'Non-pivotal tracker (TM)'
          end
        end
      end

      #h1 :text => 'Non-pivotal tracker (TM)'
      div :class => 'container-fluid' do
        div :class => 'row show-grid' do
          div :class => 'span6 column' do
            h4 :text => 'Icebox'
            div do
              input :id => :new_issue_text_field
              button :id => :add_new_issue_button, :text => 'Add New Issue', :class => 'btn primary'
            end
            icebox_panel
          end
          div :class => 'span6 column' do
            h4 :text => 'Search'
            form :class => 'form-search' do
              input :id => :search_issue_text_field, :class => 'search-query'
              button :id => :search_issue_button, :text => 'Search', :class => 'btn small'
            end
            div :class => 'list-of-issues'
          end
          div :class => 'span6 column' do
            h4 :text => 'My Work'
            span :text => 'other things here'
            div  :class => 'list-of-issues'
          end
        end
      end

      div :id => :footer, :text => "Powered by Nadeshiko #{Nadeshiko::VERSION}"
    end

    def icebox_panel
      list :id => :icebox, :class => 'list-of-issues' , :notify => true , :sortable => true

      icebox = get_element :icebox
      order_scope = OrderScope.where(:name => 'icebox').first
      order_scope ||= OrderScope.create :name => 'icebox', :data => []

      icebox.item_renderer do |record|
        item = div  :class => "well" do
          story_description = "#{record.id}: #{record.description}"
          div :text => story_description, :class => 'issue-description left'
          x = div :text => 'Delete', :class => 'btn danger right'
          x.click do
            icebox.remove_record record
          end
        end
        item.effect "highlight"
        item
      end

      icebox.onremove do |record|
        record.destroy
      end

      icebox.onsortupdate do |moved_element|
        moved_element.effect 'highlight' if moved_element
        order_scope.data = icebox.records_order
        order_scope.save!
      end

      # we use load_records instead of append_record, to skip_sort_update callback
      icebox.load_records Issue.load_in_order(order_scope.data)

    end

  end
end
