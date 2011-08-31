#!/usr/bin/env ruby

require 'sinatra'

public_dir = File.dirname(__FILE__)+ '/../public'

#set :public, public_dir

set :root, Dir.getwd
set :run, true


get '/' do
  IO.read  public_dir + '/index.html'
end

list_of_javascript_files = ['dom_crud.js',
  'FABridge.js',
  'jquery.min.js',
  'jquery-ui.min.js',
  'swfobject.js',
  'web_socket.js'
  ]

list_of_javascript_files.each do |file|
  get '/javascripts/'+ file do
    IO.read public_dir + '/javascripts/' + file
  end
end
