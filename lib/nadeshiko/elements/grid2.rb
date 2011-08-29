module Nadeshiko
  class Grid2 < Element
    attr_accessor :items,:columns,:tbody_id

    def initialize options = {}
      super options
      @tbody_id = generate_random_id
      @columns = options[:columns]
    end


    def add_item &block
      tbody = @app.get_element @tbody_id
      tbody.instance_eval &block
    end



    def setup

      table :style => default_style.merge({:width => '100%'}) do
        thead :style => default_style do
          tr :style => default_style do
            (@columns+['']).each do |c|
              th :text => c.to_s, :style => default_style.merge({'background-color'=>'#eee'})
            end
          end
        end
        tbody :id => @tbody_id
      end

    end


    def default_style
      {
        'border-width' => '1px',
        'border-collapse' => 'collapse',
        'border-spacing' => '2px',
        'border-style' => 'solid',
        'border-color' => 'gray',
        'background-color' => 'white'
      }
    end

  end

end
