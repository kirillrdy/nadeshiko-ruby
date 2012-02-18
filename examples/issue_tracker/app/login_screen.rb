class Silverforge < Nadeshiko::Application
  module LoginScreen

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

    def succeful_authentication
      get_element(:login_screen).remove
      main_layout
      issues_layout
      nav_bar_events
      issue_events
    end

  end
end
