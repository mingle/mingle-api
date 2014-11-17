# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mingle/api/version'

Gem::Specification.new do |spec|
  spec.name          = "mingle-api"
  spec.version       = Mingle::Api::VERSION
  spec.authors       = ["Xiao Li"]
  spec.email         = ["swing1979@gmail.com"]
  spec.summary       = %q{[The Mingle API gem provides simple interface for you to build ruby application talks to Mingle.}
  spec.description   = %q{[Mingle](http://getmingle.io) is a software development team collaborative tool, developed by ThoughtWorks Studios. The Mingle API gem provides simple interface for you to build ruby application talks to Mingle.}
  spec.homepage      = "https://github.com/ThoughtWorksStudios/mingle-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('api-auth')
  spec.add_dependency('multipart-post')
  spec.add_dependency('nokogiri')

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
