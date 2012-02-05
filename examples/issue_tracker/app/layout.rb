class IssueTracker < Nadeshiko::Application
  module Layout

    def login_screen
      div :id => 'login_form' ,:class => 'well' do
        h1 :text => "Please login"
        user_name = input :id => :username, :placeholder => 'Username', :class => 'input-small'
        password  = input :id => :password, :placeholder => 'Password', :type => 'password',:class => 'input-small'
        x = button :text => 'Login'
        x.click do
          user_name.val do |user_name|
            password.val do |password|
              #TODO use real users for authentication
              if user_name == 'kirillrdy' && password == 'great_password'
                get_element('login_form').remove
                initial_layout
                issue_events
              else
                append_to :login_form do
                  label :text => 'Wrong Username or Password',
                    :class => 'label label-important'
                end
              end
            end
          end
        end
      end
    end

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
              button :id => :add_new_issue_button, :text => 'Add New Issue', :class => 'btn'
            end
            icebox_panel
          end
          div :class => 'span6 column' do
            h4 :text => 'Search'
            form :class => 'form-search' do
              input :id => :search_issue_text_field, :class => 'search-query'
              div :id => :search_issue_button,  :class => 'btn btn-small' do
                i :class => 'icon-search'
                label :text => 'Search'
              end
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
          div :text => story_description, :class => 'span4'
          delete_button = div :text => 'Delete', :class => 'btn btn-danger' do
            i :class => 'icon-trash icon-white'
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
      icebox.load_records Issue.load_in_order(order_scope.data)

    end

  end
end
