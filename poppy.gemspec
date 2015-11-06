# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poppy/version'

Gem::Specification.new do |spec|
  spec.name          = "poppy"
  spec.version       = Poppy::VERSION
  spec.authors       = ["Damien Adermann"]
  spec.email         = ["damienadermann@gmail.com"]

  spec.summary       = %q{Simple Polymorphic Enumerations}
  spec.description   = %q{Simple polymorphic enumerations for ruby}
  spec.homepage      = "https://github.com/damienadermann/poppy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"

  spec.add_dependency "activesupport", "~> 4.0"
end
