require './lib/nadeshiko'

class Calendar < Nadeshiko::Application

  def onstart

    add_elements do

      div :style => {:height => '90%'} do
        h1  :id => :month_name
        div :style => {:float => :right } do
          button :id => :prev_month_button, :text => 'Prev'
          button :id => :next_month_button, :text => 'Next'
        end
        div :id => :calendar_body
      end

    end

    @date_to_display = Date.today

    render_calendar @date_to_display

    # set up handlers for next and prev buttons
    get_element(:next_month_button).onclick do
      @date_to_display = @date_to_display.next_month
      batch_messages do
        get_element(:calendar_body).empty
        render_calendar @date_to_display
      end
    end

    get_element(:prev_month_button).onclick do
      @date_to_display = @date_to_display.prev_month
      batch_messages do
        get_element(:calendar_body).empty
        render_calendar @date_to_display
      end
    end

  end



  def render_calendar(date_to_display)

    ####################################
    # Styles
    fill_parent = {:width => '100%',:height => '100%'}

    default_table_style =   {
      'border-width' => '1px',
      'border-collapse' => 'collapse',
      'border-spacing' => '2px',
      'border-style' => 'solid',
      'border-color' => 'gray',
      'background-color' => 'white',
      'vertical-align' => 'top'
    }

    default_table_row_style = default_table_style.merge(:height => '16%')
    default_table_header_style = default_table_style.merge(:height => '20px')

    # end styles
    #####################################

    calendar_for_month = date_to_display.month
    begging_of_month = date_to_display - date_to_display.day + 1
    first_day_of_the_month = begging_of_month.wday
    days_runner = - first_day_of_the_month + 1

    month_name = Date::MONTHNAMES[begging_of_month.month]

    get_element(:month_name).set_inner_html("#{date_to_display.year} #{month_name}")

    get_element(:calendar_body).instance_eval do
      table :style => default_table_style.merge(fill_parent) do

        thead do
          ['m','t','w','t','f','s','s'].each{|x| th :style => default_table_header_style, :text => x }
        end

        tbody do
          while ((begging_of_month + days_runner).mon == calendar_for_month) || ((begging_of_month + days_runner).mon == (calendar_for_month -1)) do
            tr :style => default_table_row_style do
              7.times do
                runner_date = begging_of_month + days_runner
                if runner_date.month == calendar_for_month
                  if [0,6].include? runner_date.wday
                    style = {:color => 'red'}
                  else
                    style = {:color => 'black'}
                  end
                else
                  style = {:color => '#aaa'}
                end
                td :style => default_table_style.merge(style), :text => runner_date.day
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
