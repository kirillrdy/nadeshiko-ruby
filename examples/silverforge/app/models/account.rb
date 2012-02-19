class Silverforge < Nadeshiko::Application
  class Account < ActiveRecord::Base

    has_many :users
    has_many :projects

  end
end
