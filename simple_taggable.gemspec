# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_taggable/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_taggable"
  spec.version       = SimpleTaggable::VERSION
  spec.authors       = ["joker1007"]
  spec.email         = ["kakyoin.hierophant@gmail.com"]
  spec.summary       = %q{Hyper Simple tagging plugin for ActiveRecord}
  spec.description   = %q{Hyper Simple tagging plugin for ActiveRecord}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", "~> 4"
  spec.add_runtime_dependency "activesupport", "~> 4"
  spec.add_runtime_dependency "railties", "~> 4"

  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "coveralls"
end
