#!/usr/bin/env ruby
require_relative 'boot'

class IssueTracker < Nadeshiko::Application

  include LoginScreen
  include Styling
  include EventHandlers
  include Layout
  include Methods
  include Admin

  def onstart
    issues_styling
    login_screen
  end

end

Nadeshiko::Server.run IssueTracker
