class Silverforge < Nadeshiko::Application
  class User < ActiveRecord::Base
    def self.authenticate email
      self.where(:email => email).first
    end
  end
end
