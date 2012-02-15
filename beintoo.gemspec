# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "beintoo/version"

Gem::Specification.new do |s|
  s.name        = "beintoo"
  s.version     = Beintoo::VERSION
  s.authors     = ["Enrico Carlesso", "Mattia Gheda"]
  s.email       = ["enricocarlesso@gmail.com", "ghedamat@gmail.com"]
  s.homepage    = "http://www.beintoo.com"
  s.summary     = "Ruby Wrapper for the Beintoo API"
  s.description = "This gem tries to wrap the Beintoo API (http://documentation.beintoo.com) to a ruby friendly Module meant to be used within Ruby on Rails applications"

  s.rubyforge_project = "beintoo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "supermodel"
  s.add_development_dependency "pry"
  s.add_runtime_dependency "rest-client"
  s.add_dependency "rake"
  s.add_dependency "json"
  s.add_dependency "activesupport"
end
