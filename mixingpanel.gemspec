$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mixingpanel/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mixingpanel"
  s.version     = Mixingpanel::VERSION

  s.authors     = ["Guillermo Guerrero"]
  s.email       = ["g.guerrero.bus@gmail.com"]
  s.homepage    = "https://github.com/gguerrero/mixingpanel"
  s.summary     = "High level utilities for using Mixpanel from your Rails project"
  s.description = "High level utilities for using Mixpanel from your Rails project"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "rails", ">= 3.2.14"
  s.add_dependency "jquery-rails", '~> 3.0.4'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'coffee-script'
  s.add_development_dependency 'jasmine'
end
