require "rubygems"
require "bundler/setup"

require 'em-websocket'
require 'json'
require 'digest/sha1'


elements = ['element','button','grid','dialog','grid2']
elements.each{|x| require_relative 'elements/'+x }

libs = [
  'dom_on_sockets',
  'app',
  'generic_observer',
  'server'
  ]

libs.each{|x| require_relative ''+ x}
