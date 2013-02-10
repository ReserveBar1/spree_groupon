# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spree/groupon/version"

Gem::Specification.new do |s|
  s.name        = "spree_groupon"
  s.version     = Spree::Groupon::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Boltze"]
  s.email       = ["thomas.boltze@gmail.com"]
  s.homepage    = "https://github.com/thms/spree_groupon"
  s.summary     = %q{Spree Groupon allows a site to use promots with lots of codes, one per order.}
  s.description = %q{Spree Groupon allows a site to use promots with lots of codes, one per order.}


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('spree_core', '~> 1.0.0')
end
