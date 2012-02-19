class Silverforge < Nadeshiko::Application

  class TaskLog < ActiveRecord::Base
    belongs_to :task
    belongs_to :user
  end

end

