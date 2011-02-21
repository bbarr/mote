# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mote/version"

Gem::Specification.new do |s|
  s.name        = "mote"
  s.version     = Mote::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Damian Galarza"]
  s.email       = ["galarza.d@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{MongoDB library}
  s.description = %q{TLightweight MongoDB Ruby driver abstraction}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", "3.0.0"
  s.add_dependency "activemodel", "3.0.0"
  s.add_dependency "i18n"
  s.add_dependency "mongo", ">=1.2"
  s.add_dependency "bson_ext", ">=1.2"
  s.add_dependency "fast-stemmer", ">=1.0.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
end
