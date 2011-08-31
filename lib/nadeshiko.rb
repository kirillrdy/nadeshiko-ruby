require "rubygems"
require "bundler/setup"


require 'json'
require 'digest/sha1'

require 'em-websocket'

require "nadeshiko/version"

module Nadeshiko
  # Your code goes here...
end

libs = [
  'dom_on_sockets',
  'element/dsl',
  'element/jquery',
  'element',
  'application',
  'notifier',
  'server',
  'css'
]

libs.each{|x| require_relative 'nadeshiko/'+ x}

elements = ['button','grid','dialog','grid2']
elements.each{|x| require_relative 'nadeshiko/elements/'+x }
