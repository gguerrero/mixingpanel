require 'mixingpanel/version'
require 'mixingpanel/engine'
require 'mixingpanel/helpers'
require 'mixingpanel/security'

ActionView::Base.send(:include, Mixingpanel::ViewHelpers)
