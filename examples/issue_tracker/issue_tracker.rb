#!/usr/bin/env ruby
require_relative 'boot'

class Silverforge < Nadeshiko::Application

  include LoginScreen
  include Styling
  include EventHandlers
  include Layout
  include Methods
  include Admin
  include Tasks

  def onstart
    issues_styling
    login_screen
  end

end

Nadeshiko::Server.run Silverforge
