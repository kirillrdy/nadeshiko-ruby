class Silverforge < Nadeshiko::Application
  class User < ActiveRecord::Base
    has_many :project_users
    has_many :projects, :through => :project_users

    has_many :task_logs

    def start_task task
      @current_item_description = task.description
      @current_item_start_time = Time.now
    end

    def current_work_item
      return "Doing Nothing ..." if @current_item_description.nil?
      "#{@current_item_description} #{(Time.now - @current_item_start_time).to_i}"
    end

    def self.authenticate email
      self.where(:email => email).first
    end

  end
end
