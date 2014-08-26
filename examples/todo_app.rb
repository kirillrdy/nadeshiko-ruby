require './lib/nadeshiko'

module Examples
  class Todo < Nadeshiko::Application

    def onstart
      new_task_input = input :type => 'text'
      add_button = button text: 'Add'
      ul id: :list_of_tasks  do
        3.times do
          li text: 'hello'
        end
      end

      add_button.click do
        new_task_input.val do |text|
          Nadeshiko::Notifier.trigger :item_added, text
        end
      end

      Nadeshiko::Notifier.bind :item_added do |text|
        append_to :list_of_tasks do
          li text: text
        end
      end

    end

  end
end

Nadeshiko::Server.run Examples::Todo

