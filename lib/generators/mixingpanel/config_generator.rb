module Mixingpanel
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Generates the config initializer file for Mixingpanel options"
    def copy_initializer_file
      copy_file "mixingpanel.rb", "config/initializers/mixingpanel.rb"
    end
  end
end
