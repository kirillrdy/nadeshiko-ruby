class Silverforge < Nadeshiko::Application
  module Tasks

    def issues_layout
      append_to :main_body do
        div :class => 'row' do
          div :class => 'span5' do
            h4 :text => 'Tasks'
            div do
              input :id => :new_issue_text_field
              button :id => :add_new_issue_button, :text => 'Add', :class => 'btn'
            end
            icebox_panel
          end
          div :class => 'span6' do
            h4 :text => 'Current'
            div :class => 'list-of-issues'
          end
          div :class => 'span6 column' do
            h4 :text => 'Review'
            div  :class => 'list-of-issues'
          end
        end
      end
    end


    def icebox_panel
      list :id => :icebox, :class => 'list-of-issues' , :notify => true , :sortable => true

      icebox = get_element :icebox
      order_scope = OrderScope.where(:name => 'icebox').first
      order_scope ||= OrderScope.create :name => 'icebox', :data => []

      icebox.item_renderer do |record|
        item = div  :class => "well issue-item" do
          story_description = "#{record.id}: #{record.description}"
          div :text => story_description, :class => 'span3'
          start_button = div :class => 'btn' do
            i :class => 'icon-play'
          end
          div :class => 'btn' do
            i :class => 'icon-pencil'
          end
          delete_button = div :class => 'btn btn-danger' do
            i :class => 'icon-trash icon-white'
          end

          start_button.click do
            @current_user.start_task record
            get_element(:current_work_item).effect "highlight"
          end
          delete_button.click do
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
      icebox.load_records Task.load_in_order(order_scope.data)

    end

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
