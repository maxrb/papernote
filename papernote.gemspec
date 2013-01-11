# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'papernote/version'

Gem::Specification.new do |gem|
  gem.name          = "papernote"
  gem.version       = Papernote::VERSION
  gem.authors       = ["Paolo Gianrossi"]
  gem.email         = ["paolino.gianrossi@gmail.com"]
  gem.description   = %q{Papernote is a tool and library to generate printable templates for note taking.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/paologianrossi/papernote"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_dependency('methadone', '~> 1.2.4')
  gem.add_dependency('prawn')
end
