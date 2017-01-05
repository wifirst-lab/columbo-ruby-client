# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'columbo/version'

Gem::Specification.new do |spec|
  spec.name          = "columbo-client"
  spec.version       = Columbo::VERSION
  spec.authors       = ["Wifirst"]

  spec.summary       = "A simple Ruby client for the Columbo REST and AMQP API"
  spec.description   = "A simple Ruby client for the Columbo REST and AMQP API"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bunny", ">= 2.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
