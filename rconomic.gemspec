Gem::Specification.new do |s|
  s.name        = 'rconomic'
  s.summary     = "Wrapper for the e-conomic SOAP API."
  s.description = <<-EOS
                  Ruby wrapper for the e-conomic SOAP API, that aims at making working with the API bearable.

                  E-conomic is a web-based accounting system. For their marketing speak, see http://www.e-conomic.co.uk/about/. More details about their API at http://www.e-conomic.co.uk/integration/integration-partner/.
                  EOS
  s.authors     = ["Jakob Skjerning"]
  s.email       = 'jakob@mentalized.net'
  s.homepage    = 'https://github.com/lokalebasen/rconomic'

  s.version     = '0.1'
  s.date        = '2011-07-11'

  s.add_runtime_dependency "savon", "0.9.2"
  s.add_runtime_dependency "activesupport", "~> 3.0"

  s.files = `git ls-files`.split("\n").reject { |filename| ['.gitignore'].include?(filename) }
  s.require_path = "lib"
end