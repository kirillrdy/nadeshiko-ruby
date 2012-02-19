class Silverforge < Nadeshiko::Application
  module MainLayout

    def main_layout

      div :class => "navbar" do
        div :class => "navbar-inner" do
          div :class => "container" do
            a :class => 'brand', :text => 'Silverforge'
            ul :class => :nav do
              li :id => :home_li, :class => :active do
                a :text => 'Home', :id => :home_section_link
              end
              li :id => :admin_li, :class => 'span6' do
                a :text => 'Admin', :id => :admin_section_link
              end
              li do
                a :text => '', :id => :current_user_name
              end
              li do
                a :text => 'clock', :id => :clock_link
              end
            end
          end
          
        end
      end

      div :id => :main_body, :class => 'container-fluid' do
      end

      div :id => :footer, :text => "Powered by Nadeshiko #{Nadeshiko::VERSION}"


      EventMachine::PeriodicTimer.new(1) do
        get_element(:clock_link).text Time.now.strftime('%H:%M:%S')
      end


    end

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

  end
end
