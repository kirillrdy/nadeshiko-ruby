require './lib/nadeshiko'

class Calendar < Nadeshiko::Application

  def onstart

    add_elements do

      div :style => {:height => '500px'} do
        h1  :id => :month_name# :text => 
        button :id => :prev_month_button, :text => 'Prev'
        button :id => :next_month_button, :text => 'Next'

        div :id => :calendar_body

      end

    end

    @month_to_display = 9
    render_calendar @month_to_display

    get_element(:next_month_button).onclick do
      get_element(:calendar_body).empty
      @month_to_display += 1
      batch_messages do
        render_calendar @month_to_display
      end
    end

    get_element(:prev_month_button).onclick do
      get_element(:calendar_body).empty
      @month_to_display -= 1
      render_calendar @month_to_display
    end

  end



  def render_calendar(calendar_for_month)
        fill_parent = {:width => '100%',:height => '100%'}

        default_table_style =   {
          'border-width' => '1px',
          'border-collapse' => 'collapse',
          'border-spacing' => '2px',
          'border-style' => 'solid',
          'border-color' => 'gray',
          'background-color' => 'white'
        }

        default_table_row_style = default_table_style.merge(:height => '20%')
        default_table_header_style = default_table_style.merge(:height => '20px')

        begging_of_month = Date.new(2011,calendar_for_month,1)
        first_day_of_the_month = begging_of_month.wday
        days_runner = - first_day_of_the_month + 1

        get_element(:month_name).set_inner_html(Date::MONTHNAMES[begging_of_month.month])

        get_element(:calendar_body).instance_eval do
          table :style => default_table_style.merge(fill_parent) do

            thead do
              ['m','t','w','t','f','s','s'].each{|x| th :style => default_table_header_style, :text => x }
            end

            tbody do
              while ((begging_of_month + days_runner).mon == calendar_for_month) || ((begging_of_month + days_runner).mon == (calendar_for_month -1)) do
                tr :style => default_table_row_style do
                  7.times do
                    td :style => default_table_style, :text => (begging_of_month + days_runner).day
                    days_runner += 1
                  end
                end
              end
            end

          end # table
        end # instance_eval
  end
end

Nadeshiko::Server.run Calendar
