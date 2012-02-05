class IssueTracker < Nadeshiko::Application
  module Styling
    def issues_styling
      append '<link rel="stylesheet" href="/bootstrap/css/bootstrap.css">'

      style do
        {
          'body' => {
            'padding-top' => '40px'
          },
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
            height: '800px',
            overflow: 'auto',
            'border-radius' => '6px'
          },
          '.well' => {
            'margin-bottom' =>  '1px'
          }

        }
      end
    end
  end
end
