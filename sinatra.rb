require 'sinatra'

get '/' do
  IO.read 'index.html'
end
