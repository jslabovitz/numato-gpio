#encoding: utf-8

Gem::Specification.new do |s|
  s.name          = 'numato-gpio'
  s.version       = '0.1'
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

  s.add_dependency 'rubyserial', '~> 0.6'

  s.add_development_dependency 'bundler', '~> 2.4'
  s.add_development_dependency 'rake', '~> 13.1'
end