require 'sinatra'

get '/' do
  IO.read 'public/index.html'
end
