#!/usr/bin/env ruby
require_relative 'boot'

class IssueTracker < Nadeshiko::Application

  include Styling
  include EventHandlers
  include Layout
  include Methods

  def onstart
    issues_styling
    login_screen
  end

end

Nadeshiko::Server.run IssueTracker
