require_relative 'boot'

class Silverforge < Nadeshiko::Application

  silverpond_account  = Account.new :name => 'Silverpond'
  silverpond_account.save!

  kirill = User.new :email => 'kirillrdy@silverpond.com.au', :name => 'Kirill Radzikhovskyy'
  kirill.save!

  silverpond_account.users << kirill

  silverforge = silverpond_account.projects.new :name => 'Silverforge'
  silverforge.users << kirill


end


