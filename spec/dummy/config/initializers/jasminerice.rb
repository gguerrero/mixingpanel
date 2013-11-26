# spec/dummy/config/initializers/jasminerice.rb

Rails.application.config.assets.paths << ENGINE_NAME::Engine.root.join("spec", "javascripts") << ENGINE_NAME::Engine.root.join("spec", "stylesheets")

# Add engine to view path so that spec/javascripts/fixtures are accessible
ActionController::Base.prepend_view_path ENGINE_NAME::Engine.root
