class Silverforge < Nadeshiko::Application
  class Project < ActiveRecord::Base

    has_many :project_users
    has_many :users, :through => :project_users


  end
end
