require 'mixingpanel/helpers'

module Mixingpanel
  class Engine < ::Rails::Engine
    # Adds the ViewHelpers into ActionView::Base
    initializer "private_pub.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end