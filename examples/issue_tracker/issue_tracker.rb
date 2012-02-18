#!/usr/bin/env ruby
require_relative 'boot'

class Silverforge < Nadeshiko::Application

  include Styling
  include LoginScreen

  include MainLayout
  include Methods
  include Admin
  include Tasks

  def onstart
    main_styling
    login_screen
  end

end

Nadeshiko::Server.run Silverforge
