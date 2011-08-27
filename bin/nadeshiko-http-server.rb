#!/usr/bin/env ruby

require 'sinatra'

public_dir = File.dirname(__FILE__)+ '/../public'

set :public, public_dir

get '/' do
  IO.read  public_dir + '/index.html'
end
