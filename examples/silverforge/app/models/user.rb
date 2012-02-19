class Silverforge < Nadeshiko::Application
  class User < ActiveRecord::Base
    has_many :project_users
    has_many :projects, :through => :project_users
    def self.authenticate email
      self.where(:email => email).first
    end
  end
end
