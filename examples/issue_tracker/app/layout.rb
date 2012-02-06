class IssueTracker < Nadeshiko::Application
  module Layout

    def succeful_authentication
      get_element(:login_screen).remove
      initial_layout
      issues_layout
      nav_bar_events
      issue_events
    end

    def login_screen

      div :id => :login_screen, :style=>"position: relative; top: auto; left: auto; margin: 0 auto; z-index: 1", :class=>"modal" do
        div :class=>"modal-header" do
          a 'data-dismiss' => "modal", :class=>"close", :href=>"#", :text => 'X'
          h3 :text => 'Please login'
        end
        div :class=>"modal-body", :id => 'modal-body' do
          form :class => 'form-horizontal' do
            div :class => 'control-group' do
              label :class => 'control-label', :text => 'Username'
              div :class => 'controls' do
                input :id => :username, :placeholder => 'Username', :class => ''
              end
            end
            div :class => 'control-group' do
              label :class => 'control-label', :text => 'Password'
              div :class => 'controls' do
                input :id => :password, :placeholder => 'Password', :type => 'password',:class => ''
              end
            end

          end
        end
        div :class=>"modal-footer" do
          a :class=>"btn btn-primary", :href=>"#", :text =>'Login', :id => 'login_button'
        end
      end

      get_element(:password).keydown do |key|
        if key == 13
          succeful_authentication
        end
      end

      get_element(:login_button).click do
        get_element(:username).val do |user_name|
          get_element(:password).val do |password|
            #TODO use real users for authentication
            if user_name == 'kirillrdy' && password == 'password'
              succeful_authentication
            else
              append_to 'modal-body' do
                label :text => 'Wrong Username or Password',
                  :class => 'label label-important'
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
            ul :class => :nav do
              li :id => :home_li, :class => :active do
                a :text => 'Home', :id => :home_section_link
              end
              li :id => :admin_li do
                a :text => 'Admin', :id => :admin_section_link
              end
            end
          end
          
        end
      end

      div :id => :main_body, :class => 'container-fluid' do
      end

      div :id => :footer, :text => "Powered by Nadeshiko #{Nadeshiko::VERSION}"
    end

    def issues_layout
      append_to :main_body do
        div :class => 'row' do
          div :class => 'span6' do
            h4 :text => 'Icebox'
            div do
              input :id => :new_issue_text_field
              button :id => :add_new_issue_button, :text => 'Add New Issue', :class => 'btn'
            end
            icebox_panel
          end
          div :class => 'span6' do
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
          div :class => 'btn' do
            i :class => 'icon-star-empty'
          end
          div :class => 'btn' do
            i :class => 'icon-ok'
          end
          div :class => 'btn' do
            i :class => 'icon-pencil'
          end
          delete_button = div :class => 'btn btn-danger' do
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

    def add_admin_layout
      append_to :main_body do
        table :class => 'table table-striped' do
          thead do
            tr do
              th :text => 'Id'
              th :text => 'description'
              th :text => 'Actions'
            end
          end
          tbody do
            for issue in Issue.all
              tr do
                td :text => issue.id
                td :text => issue.description
                td do
                  div :text => 'Delete', :class => 'btn'
                end
              end
            end
          end
        end
      end
    end

  end
end
