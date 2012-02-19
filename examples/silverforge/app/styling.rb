class Silverforge < Nadeshiko::Application
  module Styling
    def main_styling
      append '<link rel="stylesheet" href="/bootstrap/css/bootstrap.css">'

      style do
        {
          '.right' => {
            :float => 'right'
          },
          '.left' => {
            :float => 'left'
          },
          '.list-of-issues' => {
            background:  '#eee',
            height: '700px',
            overflow: 'auto',
            'border-radius' => '6px'
          },
          '.well' => {
            'margin-bottom' =>  '1px'
          },
          'input' => {
            :height => '28px'
          },
          '#add_new_issue_button' => {
            'margin-bottom' => '9px'
          },
          ".issue-item" => {
            :padding => '5px'
          }

        }
      end
    end
  end
end
