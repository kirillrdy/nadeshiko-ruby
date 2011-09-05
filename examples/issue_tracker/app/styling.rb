module Styling
  def issues_styling
    append '<link rel="stylesheet" href="http://twitter.github.com/bootstrap/assets/css/bootstrap-1.2.0.min.css">'

    style do
      {
        '.issue-description' => {
          :width => '260px'
        },
        '.right' => {
          :float => 'right'
        },
        '.left' => {
          :float => 'left'
        },
        '#list_of_issues' => {
          background:  '#eee',
          height: '800px'
        },
        '.well' => {
          'margin-bottom' =>  '1px'
        }

      }
    end

#    style do
#      {
#        '#list_of_issues' => {
#          :height => '80%',
#          :width => '400px',
#          #:border => '1px solid gray'
#          :background => '#efe',
#          'border-radius' => '3px',
#        },
#        '#footer' => {
#          :margin => :auto,
#          :width => '200px'
#        },
#        '.issue' => {
#          #:width => '400px',
#          :width => '100%',
#          'border-radius' => '3px',
#          :border => '1px solid gray',
#          :background => '#eee'
#        },
#        '.issue-description' => {
#          :width => '330px'
#        },
#        '.issue-buttons' => {
#          'float' => 'right'
#        }
#      }
#    end

  end
end
