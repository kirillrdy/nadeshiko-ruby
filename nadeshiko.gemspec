# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nadeshiko/version"

Gem::Specification.new do |s|
  s.name        = "nadeshiko"
  s.version     = Nadeshiko::VERSION
  s.authors     = ["Kirill Radzikhovskyy"]
  s.email       = ["kirillrdy@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Small web framework based on event machine and websockets}
  s.description = %q{same as summary}

  s.rubyforge_project = "nadeshiko"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'em-websocket'
  s.add_dependency 'sinatra'
end
