# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caser/version'

Gem::Specification.new do |spec|
  spec.name          = "caser"
  spec.version       = Caser::VERSION
  spec.authors       = ["Simon Robson"]
  spec.email         = ["shrobson@gmail.com"]
  spec.description   = %q{Simple structures for writing actions / use cases}
  spec.summary       = %q{Provides a standard approach to plugging the gap between controllers and persistence for the common cases, such as crud, in Ruby web applications.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
