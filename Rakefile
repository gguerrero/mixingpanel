require 'rubygems'
require 'rake'
require 'jasmine'
load 'lib/jasmine/compiler.rb'
load 'jasmine/tasks/jasmine.rake'

task :default => [:spec, "jasmine:ci"]

namespace :jasmine do
  namespace :ci do
    desc "Run Jasmine CI build compiling CoffeeScripts"
    task :coffee do
      Jasmine::Compiler.run
      Rake::Task['jasmine:ci'].invoke
    end
  end
end