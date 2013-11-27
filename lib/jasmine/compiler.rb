require 'pathname'
require 'fileutils'
require 'coffee_script'

module Jasmine
  class Compiler

    def self.run
      puts Jasmine.config.inspect
      compile_gem_assets
      compile_jasmine_javascripts
    end

    private
    def self.clean(dir)
      FileUtils.rm_rf dir, :secure => true
    end

    def self.compile_gem_assets
      puts "Compiling Gem assets..."

      root = File.expand_path("../../../app/assets/javascripts", __FILE__)
      destination_dir = File.expand_path("../../../spec/javascripts/generated/assets", __FILE__)

      clean(destination_dir)
      compile_coffees(root, destination_dir)
    end

    def self.compile_jasmine_javascripts
      puts "Compiling jasmine coffee scripts into javascript..."
      
      root = File.expand_path("../../../spec/javascripts/coffee", __FILE__)
      destination_dir = File.expand_path("../generated/specs", root)

      clean(destination_dir)
      compile_coffees(root, destination_dir)
    end

    def self.compile_coffees(srcdir, destdir)
      glob = File.expand_path("**/*.js.coffee", srcdir)
      Dir.glob(glob).each do |srcfile|
        srcfile = Pathname.new(srcfile)
        destfile = srcfile.sub(srcdir, destdir).sub(".coffee", "")
        compile(srcfile, destfile)
      end
    end

    def self.compile(srcfile, destfile)
      FileUtils.mkdir_p(destfile.dirname)
      File.open(destfile, "w") do |f| 
        f.write(CoffeeScript.compile(File.new(srcfile)))
      end
    end
  end
end