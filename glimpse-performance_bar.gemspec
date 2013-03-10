# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'glimpse-performance_bar/version'

Gem::Specification.new do |gem|
  gem.name          = 'glimpse-performance_bar'
  gem.version       = Glimpse::PerformanceBar::VERSION
  gem.authors       = ['Garrett Bjerkhoel']
  gem.email         = ['me@garrettbjerkhoel.com']
  gem.description   = %q{Provide a glimpse into the MySQL queries made during your application's requests.}
  gem.summary       = %q{Provide a glimpse into the MySQL queries made during your application's requests.}
  gem.homepage      = 'https://github.com/dewski/glimpse-performance_bar'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'glimpse'
end
