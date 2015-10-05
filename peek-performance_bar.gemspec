# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peek-performance_bar/version'

Gem::Specification.new do |gem|
  gem.name          = 'peek-performance_bar'
  gem.version       = Peek::PerformanceBar::VERSION
  gem.authors       = ['Garrett Bjerkhoel']
  gem.email         = ['me@garrettbjerkhoel.com']
  gem.description   = %q{Take a peek into the MySQL queries made during your application's requests.}
  gem.summary       = %q{Take a peek into the MySQL queries made during your application's requests.}
  gem.homepage      = 'https://github.com/peek/peek-performance_bar'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'peek', '>= 0.1.0'
end
