class Silverforge < Nadeshiko::Application

  module Admin

    def add_admin_layout
      append_to :main_body do
        table :class => 'table table-striped' do
          thead do
            tr do
              th :text => 'Id'
              th :text => 'description'
              th :text => 'Actions'
            end
          end
          tbody do
            for issue in Issue.all
              tr do
                td :text => issue.id
                td :text => issue.description
                td do
                  div :text => 'Delete', :class => 'btn'
                end
              end
            end
          end
        end
      end
    end

  end

end
