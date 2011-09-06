#!/usr/bin/env ruby
require_relative 'boot'

class Nadeshiko::List < Nadeshiko::Element
  def setup
    div :class => 'nadeshiko-list'
  end
end

class IssueTracker < Nadeshiko::Application

  include Styling
  include EventHandlers
  include Layout
  include Notifications
  include Methods


  def onstart
    issues_styling
    initial_layout
    setup_notificaitons
    issue_events

    list :id => :list1


  end

end

Nadeshiko::Server.run IssueTracker
