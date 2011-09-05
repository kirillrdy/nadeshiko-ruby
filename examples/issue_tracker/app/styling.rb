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
        '.list-of-issues' => {
          background:  '#eee',
          height: '800px'
        },
        '.well' => {
          'margin-bottom' =>  '1px'
        }

      }
    end
  end
end
