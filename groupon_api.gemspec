# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'groupon_api/version'

Gem::Specification.new do |gem|
  gem.name          = "groupon_api"
  gem.version       = GrouponApi::VERSION
  gem.authors       = ["Bryan Liff"]
  gem.email         = ["bliff@minerva-group.com"]
  gem.summary       = %q{Groupon API gem}
  gem.description   = %q{Provides a Ruby gem wrapper for the Groupon API}
  gem.homepage      = "https://github.com/minerva-group/groupon_api"
  gem.license       = "MIT"

  gem.files         = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport', '~> 4.2'

  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency 'rspec', '~> 3.2'
end
