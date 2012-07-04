# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'rconomic/version'

Gem::Specification.new do |s|
  s.name        = 'rconomic'
  s.summary     = "Wrapper for e-conomic.dk's SOAP API."
  s.description = <<-EOS
                  Ruby wrapper for the e-conomic SOAP API, that aims at making working with the API bearable.

                  E-conomic is a web-based accounting system. For their marketing speak, see http://www.e-conomic.co.uk/about/. More details about their API at http://www.e-conomic.co.uk/integration/integration-partner/.
                  EOS
  s.authors     = ["Jakob Skjerning"]
  s.email       = 'jakob@mentalized.net'
  s.homepage    = 'https://github.com/lokalebasen/rconomic'

  s.version     = Rconomic::VERSION
  s.platform    = Gem::Platform::RUBY

  # As long as we use Savon 0.9.5, we need to tie down the max version
  # of gyoku as 0.4.5 is not backwards compatible. If we update Savon,
  # we should remove the gyoku constraint.
  s.add_runtime_dependency "savon", "0.9.5"
  s.add_runtime_dependency "gyoku", "0.4.4"

  s.add_runtime_dependency "activesupport", "~> 3.0"

  s.files         = `git ls-files`.split("\n").reject { |filename| ['.gitignore'].include?(filename) }
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
end
