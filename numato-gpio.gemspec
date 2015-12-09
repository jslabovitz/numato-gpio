#encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'numato-gpio/version'

Gem::Specification.new do |s|
  s.name          = 'numato-gpio'
  s.version       = NumatoGPIO::VERSION
  s.summary       = 'Interfaces with Numato GPIO board via USB interface.'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
NumatoGPIO interfaces with Numato GPIO board via USB interface.
  }
  s.homepage      = 'http://github.com/jslabovitz/numato-gpio'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'rubyserial'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end