require 'sinatra/base'
require 'thin'

module Nadeshiko

  class HttpServer < Sinatra::Base

    public_dir = File.dirname(__FILE__)+ '/../../public'

    # we used to set public_dir for serving bundled assets
    # but that proved hard when used in other projects
    # so now we use default public_dir
    # and generate hardwired routes for bundled files
    #set :public, public_dir

    set :root, Dir.getwd
    set :run, true


    get '/' do
      IO.read  public_dir + '/index.html'
    end

    list_of_javascript_files = ['dom_crud.js',
      'FABridge.js',
      'jquery-1.7.1.min.js',
      'jquery-ui-1.8.17.custom.min.js',
      'swfobject.js',
      'web_socket.js'
      ]

    list_of_javascript_files.each do |file|
      get '/javascripts/'+ file do
        IO.read public_dir + '/javascripts/' + file
      end
    end

  end

  class Server

    def self.run application

      EventMachine.run do
        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |web_socket|
          web_socket.onopen do
            dom_on_sockets = DomOnSockets.new(web_socket)
            app = application.new dom_on_sockets
            app.start
          end
        end
        HttpServer.run!({:port=> 3000 })
      end

    end

  end

end
