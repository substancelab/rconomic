# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "rconomic/version"

Gem::Specification.new do |s|
  s.name        = "rconomic"
  s.summary     = "Wrapper for e-conomic.dk's SOAP API."
  s.description = <<-EOS
                  Ruby wrapper for the e-conomic SOAP API, that aims at making working with the API bearable.

                  E-conomic is a web-based accounting system. For their marketing speak, see http://www.e-conomic.co.uk/about/. More details about their API at http://www.e-conomic.co.uk/integration/integration-partner/.
                  EOS
  s.authors     = ["Jakob Skjerning"]
  s.email       = "jakob@mentalized.net"
  s.homepage    = "https://github.com/lokalebasen/rconomic"
  s.license     = "MIT"
  s.version     = Rconomic::VERSION
  s.platform    = Gem::Platform::RUBY

  s.add_runtime_dependency "savon", "~> 2.2"
  s.add_development_dependency "rspec", "> 3.0"

  s.files         = `git ls-files`.split("\n").reject { |filename| [".gitignore"].include?(filename) }
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
end
