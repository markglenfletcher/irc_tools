# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'irc_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "irc_tools"
  spec.version       = IrcTools::VERSION
  spec.authors       = ["Mark Glen Fletcher"]
  spec.email         = ["markglenfletcher@googlemail.com"]
  spec.summary       = %q{TODO}
  spec.description   = %q{TODO}
  spec.homepage      = "https://github.com/markglenfletcher/irc_tools"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib","test"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '~> 5.4', '>= 5.4.2'
  spec.add_development_dependency 'mocha', '~> 1.1', '>= 1.1.0'
end
