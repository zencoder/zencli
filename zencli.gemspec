# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'yaml'
require 'zencli/versionize'
require 'zencli/version'

Gem::Specification.new do |spec|
  spec.name          = "zencli"
  spec.version       = ZenCLI::VERSION
  spec.authors       = ["Brandon Arbini"]
  spec.email         = ["b@arbini.com"]
  spec.summary       = "Zencoder's CLI helpers."
  spec.description   = "Helpers for CLI gems."
  spec.homepage      = "https://github.com/zencoder/zencli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "colored", "~> 1.2"
  spec.add_dependency "terminal-table", "~> 1.4.5"
  spec.add_dependency "httparty", "~> 0.13.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "simplecov", "~> 0.7.1"
  spec.add_development_dependency "fuubar", "~> 1.1.1"
  spec.add_development_dependency "guard-rspec", "~> 3.0.2"
  spec.add_development_dependency "vcr", "~> 2.5.0"
  spec.add_development_dependency "webmock", "~> 1.13.0"
end
