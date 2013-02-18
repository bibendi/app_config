# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'app_config/version'

Gem::Specification.new do |gem|
  gem.name          = "app_config"
  gem.version       = Conf::VERSION
  gem.authors       = ["merkushin"]
  gem.email         = ["merkushin.m.s@gmail.com"]
  gem.description   = %q{Гем для хранения настроек приложения}
  gem.summary       = %q{Гем для хранения настроек приложения}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'rails', '>= 3.0.19'
end
