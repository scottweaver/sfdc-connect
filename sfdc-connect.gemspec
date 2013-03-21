# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sfdc-connect/version'

Gem::Specification.new do |gem|
  gem.name          = "sfdc-connect"
  gem.version       = Sfdc::Connect::VERSION
  gem.authors       = ["Scott T Weaver"]
  gem.email         = ["scott.t.weaver@gmail.com"]
  gem.description   = %q{API for connecting to SFDC Force.com RESTful API}
  gem.summary       = %q{API for connecting to SFDC Force.com RESTful API}
  gem.homepage      = "https://github.com/scottweaver/sfdc-connect"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_dependency 'httparty' 
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('simplecov')
end
