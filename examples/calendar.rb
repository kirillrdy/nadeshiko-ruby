require './lib/nadeshiko'

class Calendar < Nadeshiko::Application

  def onstart

    setup_styles

    div :style => {:height => '90%'} do
      h1  :id => :month_name
      div :style => {:float => :right } do
        button :id => :prev_month_button, :text => 'Prev'
        button :id => :next_month_button, :text => 'Next'
      end
      div :id => :calendar_body
    end

    @date_to_display = Date.today

    render_calendar @date_to_display

    # set up handlers for next and prev buttons
    get_element(:next_month_button).click do
      @date_to_display = @date_to_display.next_month
      batch_messages do
        render_calendar @date_to_display
      end
    end

    get_element(:prev_month_button).click do
      @date_to_display = @date_to_display.prev_month
      batch_messages do
        render_calendar @date_to_display
      end
    end

  end

  def render_calendar(date_to_display)

    calendar_for_month = date_to_display.month
    beginning_of_month = date_to_display - date_to_display.day + 1


    first_day_of_the_month = beginning_of_month.wday
    puts first_day_of_the_month
    first_day_of_the_month = 7 if first_day_of_the_month == 0

    days_runner = - first_day_of_the_month + 1

    month_name = Date::MONTHNAMES[beginning_of_month.month]

    get_element(:month_name).text("#{date_to_display.year} #{month_name}")

    get_element(:calendar_body).empty
    add_elements_to(:calendar_body) do
      table do
        render_header_for_monthly_view
        tbody do
          while (beginning_of_month + days_runner).mon != (date_to_display).next_month.mon do
            tr :class => 'table-row' do
              7.times do
                render_day_cell_for_monthly_view(beginning_of_month + days_runner,calendar_for_month)
                days_runner += 1
              end
            end
          end
        end

      end # table
    end
  end
  
  def render_header_for_monthly_view
    thead do
      ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'].
        each{|x| th :class => 'table-header', :text => x }
    end
  end
  
  def render_day_cell_for_monthly_view runner_date,calendar_for_month

    if runner_date.month == calendar_for_month
      if [0,6].include? runner_date.wday
        cell_class = 'weekend'
      else
        cell_class = 'weekday'
      end
    else
      cell_class = 'other-month'
    end
    td :class => cell_class do
      span :text => runner_date.day
      ul :class => 'day-lists' do
        li :class => 'day-event blue' do
          span :text => 'Some Event'
        end
        li :class => 'day-event green' do
          span :text => 'Other Event'
        end
      end.sortable :connectWith => '.day-lists'
    end

  end


  def setup_styles
    fill_parent = {:width => '100%',:height => '100%'}

    default_table_style = {
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

#aqua, black, blue, fuchsia, gray, grey, green, lime, maroon, navy, olive, purple, red, silver, teal, white, yellow

    # end styles
    #####################################
    style do
      {
        'table-header' => default_table_header_style,
        'table-row' => default_table_row_style,
        'table' => default_table_style.merge(fill_parent),
        'td' =>  default_table_style.merge(:width => '14%'),
        'td.weekend' => {:color => 'red'},
        'td.weekday'=> {:color => 'black'},
        'ul' => {
          'list-style-type' =>  'none',
          'margin' => '0px',
          'padding' => '0px',
          'height' => '100%'
        },
        'td.other-month' => {:color => '#aaa'},
        '.day-event' => {
          :padding => '1px',
          'margin-bottom' => '1px',
          'background-color' => 'blue',
          'border-radius' => '3px',
          :color => 'white'
        },
        '.green' => {
          'background-color' => 'green'
        },
        '.orange' => {
          'background-color' => 'orange'
        }
      }
    end

  end

end

Nadeshiko::Server.run Calendar
