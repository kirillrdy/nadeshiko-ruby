#!/usr/bin/env ruby
require_relative 'boot'
require_relative 'silverforge'

class SilverforgeTest < Silverforge


  def onstart
    `rake db:drop db:create db:migrate`
    User.create! :email => 'kirillrdy@silverpond.com.au', :name => 'Kirill'
    super

    get_element(:username).val 'kirillrdy@silverpond.com.au'
    get_element(:login_button).trigger 'click'

    Thread.new do
      sleep 1

      get_element(:new_issue_text_field).val 'User should be able to add a task'
      get_element(:add_new_issue_button).trigger 'click'
    end
  end

end

Nadeshiko::Server.run SilverforgeTest
