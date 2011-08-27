Nadeshiko
=========

  Small but powerful framework to develop realtime apps with nothing but Ruby

Requirements
-------------

 * ruby 1.9.3 + ( it should work with 1.9.2 )
 * Chrome 4+ ( I use 15+ )
 * Firefox 6+


Hello World
-------------

Your basic hello world

        gem install nadeshiko
        $EDITOR hello_world.rb

        require 'nadeshiko'
        class HelloWord < Nadeshiko::Application
          def onstart
            add_elements do
              span :text => 'Hello World'
            end
          end
        end
        
        Nadeshiko::Server.run HelloWord
        # end of file
        
        
        nadeshiko-http-server.rb &
        ruby hello_world.rb

In your browser
navigate to *http://localhost:4567/*


Examples
----------------
see applications in examples folder
